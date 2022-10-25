
using Gtk;

namespace Diodon.Plugins
{


	public class Append_enterPlugin : Peas.ExtensionBase, Peas.Activatable
	{
		private Controller controller;
		private Gtk.MenuItem menuitem;

		public Object object { get; construct; }

		public Append_enterPlugin ()
		{
			Object ();
		}

		public void activate ()
		{
			controller = object as Controller;

			menuitem = new Gtk.MenuItem.with_label ("xxxxtem");
			menuitem.activate.connect (() => append_enter.begin ());
			controller.add_static_recent_menu_item.begin (menuitem);
		}

		public void deactivate () {
			menuitem.destroy();
		}

		public void update_state () {}
 
		private async void append_enter ()
		{
			var item = (yield controller.get_recent_items ()).data;
			var dialog = new Dialog.with_buttons ("Edit", null, DialogFlags.MODAL, "_OK", ResponseType.ACCEPT, "_Cancel", ResponseType.REJECT, null);
			var text_view = new TextView ();
			text_view.top_margin = 20;
			text_view.right_margin = 20;
			text_view.bottom_margin = 20;
			text_view.left_margin = 20;
			text_view.buffer.text = item.get_text ();
			text_view.buffer.text = text_view.buffer.text + "\n";
			dialog.get_content_area ().add (text_view);
			dialog.response.connect ((id) =>
				{
					switch (id)
					{
						case ResponseType.ACCEPT:
							controller.remove_item.begin (item);
							controller.add_text_item.begin (item.get_clipboard_type (), text_view.buffer.text, item.get_origin ());
							dialog.destroy ();
							break;
						case ResponseType.REJECT:
							dialog.destroy ();
							break;
					}
				});
			dialog.show_all ();
			dialog.run ();
		}
	}
}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module)
{
	Peas.ObjectModule objmodule = module as Peas.ObjectModule;
	objmodule.register_extension_type (typeof (Peas.Activatable),
									   typeof (Diodon.Plugins.Append_enterPlugin));
}
