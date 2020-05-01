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

public class Gitscover.API
{
    public static void get ()
    {
        string api_url = "https://api.github.com/repositories";

        Soup.Session session = new Soup.Session ();
        session.user_agent = "Gitscovery-app";
        Soup.Message message = new Soup.Message ("GET", api_url);
        session.send_message (message);
        Json.Parser parser = new Json.Parser ();

        try
        {
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);
            var root_array = parser.get_root ().get_array ();

            int index = Random.int_range(0, (int)root_array.get_length ());

            var repos = root_array.get_elements ();
            var repo = repos.nth(index).data.get_object ();
            stdout.printf ("%s\n%s\n%s\n\n",
                  repo.get_string_member ("node_id"),
                  repo.get_string_member ("name"),
                  repo.get_string_member ("full_name"));


        }
        catch (Error e)
        {
            stderr.printf ("I guess something is not working...\n");
        }
    }
}
