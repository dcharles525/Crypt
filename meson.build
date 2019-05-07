project ('com.github.dcharles525.crypt', 'vala', 'c')

gnome = import ('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')
add_global_arguments ('-DGETTEXT_PACKAGE="' + meson.project_name () + '"', language:'c')

executable(
    meson.project_name(),
    'src/Caroline.vala',
    'src/Services/Coin.vala',
    'src/Crypt.vala',
    'src/Services/Draw.vala',
    'src/Services/Database.vala',
    'src/Services/CoinList.vala',
    'src/Services/CoinLimit.vala',
    'src/MainPage/MainPageCharts.vala',
    'src/MainPage/ChartButtonGroup.vala',
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
      dependency('granite')
    ],
    install: true
)

subdir ('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
