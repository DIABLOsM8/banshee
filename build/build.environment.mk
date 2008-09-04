# Initializers
MONO_BASE_PATH = 
MONO_ADDINS_PATH =

# Install Paths
DEFAULT_INSTALL_DIR = $(pkglibdir)
BACKENDS_INSTALL_DIR = $(DEFAULT_INSTALL_DIR)/Backends
EXTENSIONS_INSTALL_DIR = $(DEFAULT_INSTALL_DIR)/Extensions

# External libraries to link against, generated from configure
LINK_SYSTEM = -r:System
LINK_SYSTEM_WEB = -r:System.Web
LINK_SQLITE = -r:System.Data -r:Mono.Data.SqliteClient
LINK_CAIRO = -r:Mono.Cairo
LINK_MONO_POSIX = -r:Mono.Posix
LINK_ICSHARP_ZIP_LIB = -r:ICSharpCode.SharpZipLib
LINK_MONO_ZEROCONF = $(MONO_ZEROCONF_LIBS)
LINK_GLIB = $(GLIBSHARP_LIBS)
LINK_GTK = $(GTKSHARP_LIBS)
LINK_GCONF = $(GCONFSHARP_LIBS)
LINK_GNOME = $(GNOMESHARP_LIBS)
LINK_DBUS = $(NDESK_DBUS_LIBS)
LINK_TAGLIB = $(TAGLIB_SHARP_LIBS)
LINK_IPOD = $(IPODSHARP_LIBS)
LINK_BOO = $(BOO_LIBS)
LINK_WEBKIT = $(WEBKIT_LIBS)
LINK_MONOTORRENT_DBUS = $(MONOTORRENT_DBUS_LIBS)

LINK_MONO_ADDINS_DEPS = $(MONO_ADDINS_LIBS)
LINK_MONO_ADDINS_SETUP_DEPS = $(MONO_ADDINS_SETUP_LIBS)
LINK_MONO_ADDINS_GUI_DEPS = $(MONO_ADDINS_GUI_LIBS)

DIR_BIN = $(top_builddir)/bin

# Hyena
REF_HYENA = $(LINK_SYSTEM) $(LINK_SQLITE) $(LINK_MONO_POSIX)
LINK_HYENA = -r:$(DIR_BIN)/Hyena.dll
LINK_HYENA_DEPS = $(REF_HYENA) $(LINK_HYENA)

# Hyena.Gui
REF_HYENA_GUI = $(LINK_HYENA_DEPS) $(LINK_MONO_POSIX) $(LINK_CAIRO) $(LINK_GTK)
LINK_HYENA_GUI = -r:$(DIR_BIN)/Hyena.Gui.dll
LINK_HYENA_GUI_DEPS = $(REF_HYENA_GUI) $(LINK_HYENA_GUI)

# Lastfm
REF_LASTFM = $(LINK_SYSTEM) $(LINK_SYSTEM_WEB) $(LINK_MONO_MEDIA) $(LINK_MONO_POSIX) $(LINK_HYENA) $(LINK_ICSHARP_ZIP_LIB) 
LINK_LASTFM = -r:$(DIR_BIN)/Lastfm.dll
LINK_LASTFM_DEPS = $(REF_LASTFM) $(LINK_LASTFM)

# Lastfm.Gui
REF_LASTFM_GUI = $(LINK_GLIB) $(LINK_GTK) $(LINK_LASTFM_DEPS)
LINK_LASTFM_GUI = -r:$(DIR_BIN)/Lastfm.Gui.dll
LINK_LASTFM_GUI_DEPS = $(REF_LASTFM_GUI) $(LINK_LASTFM_GUI)

REF_MIGO = $(LINK_HYENA_DEPS) $(LINK_SYSTEM_WEB)
LINK_MIGO = -r:$(DIR_BIN)/Migo.dll
LINK_MIGO_DEPS = $(REF_MIGO) $(LINK_MIGO)

# Mono.Media
REF_MONO_MEDIA = $(LINK_SYSTEM)
LINK_MONO_MEDIA = -r:$(DIR_BIN)/Mono.Media.dll
LINK_MONO_MEDIA_DEPS = $(REF_MONO_MEDIA) $(LINK_MONO_MEDIA)

# Mtp
REF_MTP = $(LINK_SYSTEM) $(LINK_MONO_POSIX)
LINK_MTP = -r:$(DIR_BIN)/Mtp.dll
LINK_MTP_DEPS = $(REF_MTP) $(LINK_MTP)

# Karma
REF_KARMA = $(LINK_SYSTEM) $(LINK_MONO_POSIX)
LINK_KARMA = $(KARMASHARP_LIBS)
LINK_KARMA_DEPS = $(REF_KARMA) $(LINK_KARMA)

# MusicBrainz
REF_MUSICBRAINZ = $(LINK_SYSTEM)
LINK_MUSICBRAINZ = -r:$(DIR_BIN)/MusicBrainz.dll
LINK_MUSICBRAINZ_DEPS = $(REF_MUSICBRAINZ) $(LINK_MUSICBRAINZ)

# Core
REF_BANSHEE_CORE = $(LINK_HYENA_DEPS) $(LINK_MONO_POSIX) $(LINK_GLIB) \
	$(LINK_DBUS) $(LINK_TAGLIB) $(LINK_MONO_ADDINS_DEPS)
LINK_BANSHEE_CORE = -r:$(DIR_BIN)/Banshee.Core.dll
LINK_BANSHEE_CORE_DEPS = $(REF_BANSHEE_CORE) $(LINK_BANSHEE_CORE)

REF_BANSHEE_SERVICES = $(LINK_SQLITE) $(LINK_BANSHEE_CORE_DEPS) $(LINK_MONO_MEDIA_DEPS) $(LINK_LASTFM_DEPS)
LINK_BANSHEE_SERVICES = -r:$(DIR_BIN)/Banshee.Services.dll
LINK_BANSHEE_SERVICES_DEPS = $(REF_BANSHEE_SERVICES) $(LINK_BANSHEE_SERVICES)

REF_BANSHEE_WIDGETS = $(LINK_MONO_POSIX) $(LINK_HYENA_GUI_DEPS)
LINK_BANSHEE_WIDGETS = -r:$(DIR_BIN)/Banshee.Widgets.dll
LINK_BANSHEE_WIDGETS_DEPS = $(REF_BANSHEE_WIDGETS) $(LINK_BANSHEE_WIDGETS)

REF_BANSHEE_THICKCLIENT = $(LINK_BANSHEE_WIDGETS_DEPS) \
	$(LINK_BANSHEE_SERVICES_DEPS) $(LINK_HYENA_GUI_DEPS) $(LINK_MONO_ADDINS_SETUP_DEPS) $(LINK_MONO_ADDINS_GUI_DEPS)
LINK_BANSHEE_THICKCLIENT = -r:$(DIR_BIN)/Banshee.ThickClient.dll
LINK_BANSHEE_THICKCLIENT_DEPS = $(REF_BANSHEE_THICKCLIENT) \
	$(LINK_BANSHEE_THICKCLIENT)

REF_NEREID = $(LINK_BANSHEE_THICKCLIENT_DEPS)
REF_HALIE = $(LINK_BANSHEE_SERVICES_DEPS)
REF_BEROE = $(LINK_BANSHEE_SERVICES_DEPS)

# Dap
REF_DAP = $(LINK_BANSHEE_SERVICES_DEPS) $(LINK_BANSHEE_THICKCLIENT_DEPS)
LINK_DAP = -r:$(DIR_BIN)/Banshee.Dap.dll
LINK_DAP_DEPS = $(REF_DAP) $(LINK_DAP)
REF_DAP_MASS_STORAGE = $(LINK_DAP_DEPS)
REF_DAP_MTP = $(LINK_DAP_DEPS) $(LINK_MTP_DEPS)
REF_DAP_IPOD = $(LINK_DAP_DEPS) $(LINK_IPOD)
REF_DAP_KARMA = $(LINK_DAP_DEPS) $(LINK_KARMA_DEPS)

# Extensions
REF_EXTENSION_AUDIOCD = $(LINK_BANSHEE_THICKCLIENT_DEPS) $(LINK_MUSICBRAINZ_DEPS)
REF_EXTENSION_BOOKMARKS = $(LINK_BANSHEE_THICKCLIENT_DEPS)
REF_EXTENSION_BOOSCRIPT = $(LINK_BANSHEE_THICKCLIENT_DEPS) $(LINK_BOO)
REF_EXTENSION_COVERART = $(LINK_BANSHEE_THICKCLIENT_DEPS)
REF_EXTENSION_DAAP = $(LINK_BANSHEE_THICKCLIENT_DEPS) $(LINK_ICSHARP_ZIP_LIB) $(LINK_MONO_ZEROCONF)
REF_EXTENSION_FILESYSTEMQUEUE = $(LINK_BANSHEE_THICKCLIENT_DEPS)
REF_EXTENSION_INTERNETRADIO = $(LINK_BANSHEE_THICKCLIENT_DEPS)
REF_EXTENSION_MINIMODE = $(LINK_BANSHEE_THICKCLIENT_DEPS)
REF_EXTENSION_MULTIMEDIAKEYS = $(LINK_BANSHEE_SERVICES_DEPS)
REF_EXTENSION_NOTIFICATIONAREA = $(LINK_BANSHEE_THICKCLIENT_DEPS)
REF_EXTENSION_PLAYQUEUE = $(LINK_BANSHEE_THICKCLIENT_DEPS)
LINK_EXTENSION_PLAYQUEUE = -r:$(DIR_BIN)/Banshee.PlayQueue.dll
LINK_EXTENSION_PLAYQUEUE_DEPS = $(REF_EXTENSION_PLAYQUEUE) \
	$(LINK_EXTENSION_PLAYQUEUE)
REF_EXTENSION_LASTFM = $(LINK_BANSHEE_THICKCLIENT_DEPS) $(LINK_MONO_MEDIA) $(LINK_LASTFM) $(LINK_LASTFM_GUI)
REF_EXTENSION_NOWPLAYING = $(LINK_BANSHEE_THICKCLIENT_DEPS)
LINK_EXTENSION_NOWPLAYING = -r:$(DIR_BIN)/Banshee.NowPlaying.dll
LINK_EXTENSION_NOWPLAYING_DEPS = $(REF_EXTENSION_NOWPLAYING) \
	$(LINK_EXTENSION_NOWPLAYING)
REF_EXTENSION_PODCASTING = $(LINK_MIGO_DEPS) $(LINK_BANSHEE_THICKCLIENT_DEPS)
REF_EXTENSION_SAMPLE = $(LINK_BANSHEE_THICKCLIENT_DEPS)
REF_EXTENSION_REMOTE_AUDIO = $(LINK_BANSHEE_THICKCLIENT_DEPS) $(LINK_MONO_ZEROCONF)

# Backends
REF_BACKEND_GNOME = $(LINK_BANSHEE_SERVICES_DEPS) $(LINK_BANSHEE_THICKCLIENT_DEPS) $(LINK_GCONF) $(LINK_GNOME) $(LINK_EXTENSION_NOWPLAYING_DEPS)
REF_BACKEND_GSTREAMER = $(LINK_BANSHEE_SERVICES_DEPS) $(LINK_GLIB)
REF_BACKEND_UNIX = $(LINK_BANSHEE_CORE_DEPS) $(LINK_MONO_POSIX)
REF_BACKEND_HAL = $(LINK_BANSHEE_SERVICES_DEPS) $(LINK_DBUS)
REF_BACKEND_BNPX11 = $(LINK_EXTENSION_NOWPLAYING_DEPS)


# Build rules
# Ignoring 0278 due to a bug in gmcs: 
# http://bugzilla.ximian.com/show_bug.cgi?id=79998
BUILD_FLAGS = -debug -nowarn:0278 $(ASSEMBLY_BUILD_FLAGS)
BUILD = $(MCS) $(BUILD_FLAGS)
BUILD_LIB = $(BUILD) -target:library

# Cute hack to replace a space with something
colon:= :
empty:=
space:= $(empty) $(empty)

# Build path to allow running uninstalled
RUN_PATH = $(subst $(space),$(colon), $(MONO_BASE_PATH))

