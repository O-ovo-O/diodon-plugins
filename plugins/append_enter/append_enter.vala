using Gtk;

namespace Diodon.Plugins
{
	public class Append_enterPlugin : Peas.ExtensionBase, Peas.Activatable
	{
		private Controller controller;
		private Gtk.MenuItem menuitem;

		public Object object { owned get; construct; }
 
 
		public Append_enterPlugin ()
		{
			Object ();
		}

		public void activate ()
		{
			controller = object as Controller;
			append_enter.begin ();
		}

		public void deactivate () { 
		}

		public void update_state () {}
 
		private async void append_enter ()
		{
			var item = (yield controller.get_recent_items ()).data;
			item.set_text(item.get_text () + "\n", -1);
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
