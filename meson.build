project ('com.github.dcharles525.crypt', 'vala', 'c')

gnome = import ('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')
add_global_arguments ('-DGETTEXT_PACKAGE="' + meson.project_name () + '"', language:'c')

#Translate and install our .desktop file
i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.desktop'),
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

#Translate and install our .appdata file
i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.appdata.xml'),
    output: meson.project_name() + '.appdata.xml',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

executable(
    meson.project_name(),
    'src/Caroline.vala',
    'src/Coin.vala',
    'src/Crypt.vala',
    'src/Draw.vala',
    dependencies: [
      dependency('gtk+-3.0'),
      dependency('libsoup-2.4'),
      dependency('json-glib-1.0'),
      dependency('webkit2gtk-4.0'),
      dependency('gee-0.8'),
      dependency('gstreamer-1.0'),
      dependency('clutter-gst-3.0'),
      dependency('clutter-gtk-1.0'),
      dependency('granite')
    ],
    install: true
)

subdir ('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
