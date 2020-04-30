project('com.github.linuxhubit.gitscover', 'vala', 'c', version: '0.1.0')


gnome = import('gnome')
i18n = import('i18n')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

dependencies = [
    dependency('gobject-2.0'),
    dependency('glib-2.0'),
    dependency('granite'),
    dependency('gtk+-3.0'),
]

subdir('src')

executable(
    meson.project_name(),
    sources,
    dependencies: dependencies,
    install: true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
