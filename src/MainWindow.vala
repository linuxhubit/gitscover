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
    private Gtk.Label repo_title;
    private Gtk.Label repo_description;
    private Gtk.LinkButton repo_link;
    private Gtk.Label repo_languages;
    private Gtk.Box main;
    private Json.Array? repos = null;

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

        refresh_button.clicked.connect (() => {
            get_random_repo ();
        });

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
        repo_title = new Gtk.Label ("License");
        repo_title.get_style_context ().add_class ("repository-title");

        repo_description = new Gtk.Label (_("Meanwhile why don't you visit our repository?"));
        repo_description.get_style_context ().add_class ("repository-description");

        repo_link = new Gtk.LinkButton ("https://github.com/linuxhubit");
        repo_link.get_style_context ().add_class ("repository-link");

        repo_languages = new Gtk.Label ("");
        repo_languages.get_style_context ().add_class ("repository-language");

        
        main.add (repo_title);
        main.add (repo_description);
        main.add (repo_link);
        main.add (repo_languages);

        add (main);

        get_random_repo ();
    }

    private void get_random_repo ()
    {
        Soup.Session session = new Soup.Session ();
        session.user_agent = "gitscover-app";
        Soup.Message message;
        Json.Parser parser = new Json.Parser ();

        if(repos == null)
        {
            int page = Random.int_range(0, 999999999);
            message = new Soup.Message ("GET", "https://api.github.com/repositories?since=" + page.to_string ());
            session.send_message (message);
            if(message.status_code != 200)
            {
                repo_title.set_text ("API limit exeeded.");
                return;
            }
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);
            var root_array = parser.get_root ().get_array ();
            repos = root_array;
        }

        try
        {
            int index = Random.int_range(0, (int)repos.get_length ());
            var repo = repos.get_elements ().nth(index).data.get_object ();
            if(repo == null)
            {
                show_error_generic();
                return;
            }
            repo_title.set_text (repo.get_string_member ("full_name"));
            repo_description.set_text (repo.get_string_member ("description"));
            repo_link.set_uri (repo.get_string_member ("html_url"));
            repo_link.set_label (repo.get_string_member ("html_url"));

            message = new Soup.Message ("GET", repo.get_string_member ("languages_url"));
            session.send_message (message);
            if(message.status_code != 200)
            {
                repo_languages.set_text (_("API limit exeeded."));
                return;
            }
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);
            var languages_array = parser.get_root ().get_object ();
            string langs = "";
            foreach (var member in languages_array.get_members())
            {
                langs += (string)member + ", ";
	        }
            repo_languages.set_text (langs.substring(0, langs.length -2));
        }
        catch
        {
            show_error_generic();
        }
    }

    private void show_error_generic()
    {
        repo_title.set_text (_("I guess something is not working…"));
        repo_description.set_text (_("Meanwhile why don't you visit our repository?"));
        repo_link.set_uri ("https://github.com/linuxhubit");
        repo_link.set_label ("https://github.com/linuxhubit");
    }
}
