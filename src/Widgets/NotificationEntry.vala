/*-
 * Copyright (c) 2015 Wingpanel Developers (http://launchpad.net/wingpanel)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class NotificationEntry : Gtk.ListBoxRow {
    public Notification notification;

    private Gtk.Image icon;
    private Gtk.Label time_label;

    private string entry_icon;
    private string entry_summary;
    private string entry_body;

    public Gtk.Button clear_btn;
    public bool active = true;

    public NotificationEntry (Notification _notification) {
        this.notification = _notification;
        this.entry_icon = notification.app_icon;
        this.entry_summary = notification.summary;
        this.entry_body = notification.message_body;

        notification.time_changed.connect ((timespan) => {
            if (!indicator_opened)
                time_label.label = get_string_from_timespan (timespan);

            return this.active;
        });

        this.hexpand = true;
        add_widgets ();
    }
    
    private void add_widgets () {
        if (entry_icon == "")
            icon = new Gtk.Image.from_icon_name ("help-info", Gtk.IconSize.LARGE_TOOLBAR);
        else if (entry_icon.has_prefix ("/"))
            icon = new Gtk.Image.from_file (entry_icon);
        else
            icon = new Gtk.Image.from_icon_name (entry_icon, Gtk.IconSize.LARGE_TOOLBAR);    

        icon.use_fallback = true;      
        icon.set_alignment (0, 0);

        var root_vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
        root_vbox.margin_start = 30;

        var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
        
        var title_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 90);
        title_box.hexpand = true;

        var title_label = new Gtk.Label (entry_summary);
        title_label.lines = 3;
        title_label.get_style_context ().add_class ("h4");
        title_label.ellipsize = Pango.EllipsizeMode.END;
        title_label.max_width_chars = 40;
        title_label.set_alignment (0, 0);
        title_label.use_markup = true;
        title_label.set_line_wrap (true);
        title_label.wrap_mode = Pango.WrapMode.WORD;
          
        var body_label = new Gtk.Label (entry_body);
        body_label.margin_start = 5;
        body_label.set_alignment (0, 0);
        body_label.set_line_wrap (true);
        body_label.wrap_mode = Pango.WrapMode.WORD;  

        time_label = new Gtk.Label ("now");
        time_label.margin_end = 2;

        clear_btn = new Gtk.Button.from_icon_name ("edit-clear-symbolic", Gtk.IconSize.SMALL_TOOLBAR);  
        clear_btn.margin_top = 2; 
        clear_btn.margin_end = clear_btn.margin_top;
        clear_btn.get_style_context ().add_class ("flat");

        var box_btn = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
        box_btn.pack_start (time_label, false, false, 0);
        box_btn.pack_start (clear_btn, false, false, 0);

        title_box.pack_start (title_label, false, false, 0);
        title_box.pack_end (box_btn, false, false, 0);

        vbox.add (title_box);
        vbox.add (body_label);       
        
        hbox.add (vbox);
        root_vbox.add (hbox); 
        this.add (root_vbox);  
        this.show_all (); 
    }

    private string? get_string_from_timespan (TimeSpan timespan) {
        string suffix = _("min");
        int64 time = (timespan / timespan.MINUTE) * -1;
        if (time > 59) {
            suffix = "h";
            time = time / 60;

            if (time > 23) {
                if (time == 1)
                    suffix = " " + _("day");
                else    
                    suffix = " " + _("days");
                time = time / 24;
            }               
        }

        return time.to_string () + suffix;
    }
}