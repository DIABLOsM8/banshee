//
// StoreView.cs
//
// Author:
//   Aaron Bockover <abockover@novell.com>
//   Gabriel Burt <gburt@novell.com>
//
// Copyright 2010 Novell, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

using System;

using Gtk;

using Hyena;
using Hyena.Downloader;

using Banshee.Base;
using Banshee.IO;
using Banshee.WebBrowser;
using Banshee.WebSource;
using Banshee.AmazonMp3;

namespace Banshee.AmazonMp3.Store
{
    public class StoreView : WebView
    {
        private static string [] domains = new [] {
            "com",
            "co.uk",
            "co.jp",
            "de",
            "fr"
        };

        private static bool IsAmzContentType (string contentType)
        {
            switch (contentType) {
                // The German store uses this mimetype, see bgo#625210
                case "audio/x-amzaudio":
                // The US and hopefully all other stores use this one
                case "audio/x-amzxml":
                    return true;
            }

            return false;
        }

        public event EventHandler SignInChanged;

        public bool IsSignedIn { get; private set; }

        private string country;
        public string Country {
            get { return country ?? "geo"; }
            set { country = value; }
        }

        public StoreView ()
        {
            CanSearch = true;
            FixupJavascriptUrl = "http://integrated-services.banshee.fm/amz/amz-fixups.js";

            OssiferSession.CookieChanged += (o, n) => CheckSignIn ();

            // Ensure that Amazon knows a valid downloader is available,
            // otherwise the purchase experience is interrupted with a
            // confusing message about downloading and installing software.
            foreach (var domain in domains) {
                OssiferSession.SetCookie ("dmusic_download_manager_enabled",
                    AmzMp3Downloader.AmazonMp3DownloaderCompatVersion,
                    ".amazon." + domain, "/", TimeSpan.FromDays (365.2422));
            }

            Country = StoreSourcePreferences.StoreCountry.Get ();

            CheckSignIn ();
            FullReload ();
        }

        protected override OssiferNavigationResponse OnMimeTypePolicyDecisionRequested (string mimetype)
        {
            // We only explicitly accept (render) text/html types, and only
            // download what we can import or preview.
            if (IsAmzContentType (mimetype) || mimetype == "audio/x-mpegurl") {
                return OssiferNavigationResponse.Download;
            }

            return base.OnMimeTypePolicyDecisionRequested (mimetype);
        }

        protected override string OnDownloadRequested (string mimetype, string uri, string suggestedFilename)
        {
            if (IsAmzContentType (mimetype)) {
                var dest_uri_base = "file://" + Paths.Combine (Paths.TempDir, suggestedFilename);
                var dest_uri = new SafeUri (dest_uri_base);
                for (int i = 1; File.Exists (dest_uri);
                    dest_uri = new SafeUri (String.Format ("{0} ({1})", dest_uri_base, ++i)));
                return dest_uri.AbsoluteUri;
            } else if (mimetype == "audio/x-mpegurl") {
                Banshee.Streaming.RadioTrackInfo.OpenPlay (uri);
                Banshee.ServiceStack.ServiceManager.PlaybackController.StopWhenFinished = true;
                return null;
            }

            return null;
        }

        protected override void OnDownloadStatusChanged (OssiferDownloadStatus status, string mimetype, string destinationUri)
        {
            // FIXME: handle the error case
            if (status != OssiferDownloadStatus.Finished) {
                return;
            }

            if (IsAmzContentType (mimetype)) {
                Log.Debug ("OssiferWebView: downloaded purchase list", destinationUri);
                Banshee.ServiceStack.ServiceManager.Get<AmazonMp3DownloaderService> ()
                    .DownloadAmz (new SafeUri (destinationUri).LocalPath);
            }
        }

        public override void GoHome ()
        {
            LoadUri ("http://integrated-services.banshee.fm/amz/redirect.do/" + Country + "/home/");
        }

        public override void GoSearch (string query)
        {
            LoadUri (new Uri ("http://integrated-services.banshee.fm/amz/redirect.do/" + Country + "/search/" + query).AbsoluteUri);
        }

        public void SignOut ()
        {
            foreach (var name in new [] { "at-main", "x-main", "session-id",
                "session-id-time", "session-token", "uidb-main", "pf"}) {
                foreach (var domain in domains) {
                    OssiferSession.DeleteCookie (name, ".amazon." + domain, "/");
                }
            }

            FullReload ();
        }

        private void CheckSignIn ()
        {
            var signed_in = false;
            foreach (var domain in domains) {
                signed_in |= OssiferSession.GetCookie ("at-main", ".amazon." + domain, "/") != null;
            }

            if (IsSignedIn != signed_in) {
                IsSignedIn = signed_in;
                OnSignInChanged ();
            }
        }

        protected virtual void OnSignInChanged ()
        {
            var handler = SignInChanged;
            if (handler != null) {
                handler (this, EventArgs.Empty);
            }
        }
    }
}