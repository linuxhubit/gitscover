/*
* Copyright (c) 2019 brombinmirko (https://linuxhub.it)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: brombinmirko <send@mirko.pm>
*/

public class Gitscover.MainWindow : Gtk.Window
{
    private Gtk.HeaderBar header_bar;
    private Gtk.Button refresh_button;
    private Gtk.Label title;
    private Gtk.Label description;
    private Gtk.LinkButton link;
    private Gtk.Label language;
    private Gtk.Box main;

    construct
    {
        // set default window size
        set_size_request (800, 450);
        var gtk_settings = Gtk.Settings.get_default ();
        var css_provider = new Gtk.CssProvider ();

        // custom style
        css_provider.load_from_data(""
            + ".repository-title { font-size: 24px; margin-top: 40px;}"
            + ".repository-description { font-size: 15px;}"
            + ".repository-link { font-size: 15px;}"
            + ".repository-language { font-size: 12px;}"
        );

        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

        // create refresh button
        refresh_button = new Gtk.Button.from_icon_name ("view-refresh-symbolic");

        // create header_bar and pack buttons
        header_bar = new Gtk.HeaderBar ();
        header_bar.set_title (Constants.APP_NAME);
        header_bar.set_subtitle (Constants.APP_DESCRIPTION);
        header_bar.show_close_button = true;
        header_bar.has_subtitle = true;
        header_bar.pack_end (refresh_button);
        set_titlebar (header_bar);

        // create main box
        main = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);

        // create elements for repository data
        // TODO: populate from random github repository
        title = new Gtk.Label ("License");
        title.get_style_context ().add_class ("repository-title");

        description = new Gtk.Label ("An application that helps you finding the best license for your open source project");
        description.get_style_context ().add_class ("repository-description");

        link = new Gtk.LinkButton ("https://github.com/linuxhubit/license");
        link.get_style_context ().add_class ("repository-link");

        language = new Gtk.Label ("Vala, Python");
        language.get_style_context ().add_class ("repository-language");

        
        main.add (title);
        main.add (description);
        main.add (link);
        main.add (language);

        add (main);
    }
}
