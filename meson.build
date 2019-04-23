project ('com.github.dcharles525.crypt', 'vala', 'c')

gnome = import ('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')
add_global_arguments ('-DGETTEXT_PACKAGE="' + meson.project_name () + '"', language:'c')

executable(
    meson.project_name(),
    'src/Caroline.vala',
    'src/Coin.vala',
    'src/Crypt.vala',
    'src/Draw.vala',
    'src/Database.vala',
    'src/Structures/CoinList.vala',
    'src/Indicator/Indicator.vala',
    'src/Indicator/CoinListWidget.vala',
    dependencies: [
      dependency('gtk+-3.0'),
      dependency('libsoup-2.4'),
      dependency('json-glib-1.0'),
      dependency('webkit2gtk-4.0'),
      dependency('gee-0.8'),
      dependency('gstreamer-1.0'),
      dependency('clutter-gst-3.0'),
      dependency('clutter-gtk-1.0'),
      dependency('sqlite3'),
      dependency('granite'),
      dependency('wingpanel-2.0')
    ],
    install: true
)

subdir ('data')
subdir('po')

meson.add_install_script('meson/post_install.py')

shared_module(
    'crypt',
    'src/Indicator/Indicator.vala',
    'src/Indicator/CoinListWidget.vala',
    'src/Coin.vala',
    'src/Database.vala',
    'src/Structures/CoinList.vala',
    dependencies: [
      dependency('gtk+-3.0'),
      dependency('libsoup-2.4'),
      dependency('json-glib-1.0'),
      dependency('webkit2gtk-4.0'),
      dependency('gee-0.8'),
      dependency('gstreamer-1.0'),
      dependency('clutter-gst-3.0'),
      dependency('clutter-gtk-1.0'),
      dependency('sqlite3'),
      dependency('granite'),
      dependency('wingpanel-2.0')
    ],
    install: true,
    install_dir : '/usr/lib/x86_64-linux-gnu/wingpanel/'

)
