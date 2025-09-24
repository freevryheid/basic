
public class Inventory : GLib.Object {
    public int id { get; set; }
    public string name { get; set; }
    public string desc { get; set; }
    public int qty { get; set; }
    public bool known {get; set; }

    public Inventory (int id, string name, string desc, int qty, bool known) {
        Object (
            id: id,
            name: name,
            desc: desc,
            qty: qty,
            known: known);
    }
}




public class Basic.MainWindow : Gtk.ApplicationWindow {

    public MainWindow (Gtk.Application app) {
        Object (application: app);

        this.default_height = 480;
        this.default_width = 640;
        
        var header = new Gtk.HeaderBar ();
        this.set_titlebar (header);

        var stack = new Gtk.Stack ();

        var lbl1 = new Gtk.Label ("Page 1");
        var lbl2 = new Gtk.Label ("Page 2");

        var label = new Gtk.Label ("Hello World!");
        label.hexpand = label.vexpand = true;
        
        var button = new Gtk.Button.with_label ("Click Me!");

        button.clicked.connect (() => {
          var str = label.label;
          var temp_str = str.reverse ();
          label.label = temp_str;
        });

        var box1 = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        box1.append (label);
        box1.append (button);
        
        var inventory = new GLib.ListStore(typeof (Inventory));
        var selection_model = new Gtk.SingleSelection (inventory) {
            autoselect = true
        };

        inventory.append (new Inventory(1, "Bread", "a day, keeps the doctor away", 3, true));
        inventory.append (new Inventory(2, "Water", "the essence of life", 3, true));
        inventory.append (new Inventory(3, "Fur Cloak", "a day, keeps the doctor away", 1, true));

        var list_view_factory = new Gtk.SignalListItemFactory ();
        list_view_factory.setup.connect (on_list_view_setup);
        list_view_factory.bind.connect (on_list_view_bind);

        var list_view_header_factory = new Gtk.SignalListItemFactory ();
        list_view_header_factory.setup.connect (on_list_view_header_setup);
        list_view_header_factory.bind.connect (on_list_view_header_bind);

        var list_view = new Gtk.ListView (selection_model, list_view_factory);
        list_view.header_factory = list_view_header_factory;


        

        stack.add_titled (lbl1, "page1", "Page 1");
        stack.add_titled (lbl2, "page2", "Page 2");
        stack.add_titled (box1, "page3", "Page 3");
        stack.add_titled (list_view, "page4", "Inv");

        var sidebar = new Gtk.StackSidebar ();
        sidebar.set_stack (stack);
        //
        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        box.append (sidebar);
        box.append (stack);
        

        this.child = box;
    }

    private void on_list_view_setup (Gtk.SignalListItemFactory factory, GLib.Object list_item_obj) {
        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 4);
        var name_label = new Gtk.Label ("");
        name_label.halign = Gtk.Align.START;

        var id_label = new Gtk.Label ("");
        id_label.halign = Gtk.Align.START;

        vbox.append (name_label);
        vbox.append (id_label);
        ((Gtk.ListItem) list_item_obj).child = vbox;
    }

    private void on_list_view_bind (Gtk.SignalListItemFactory factory, GLib.Object list_item_obj) {
        var list_item = (Gtk.ListItem) list_item_obj;
        var item_data = (Inventory) list_item.item;
        var vbox = (Gtk.Box) list_item.child;
        var name_label = (Gtk.Label) vbox.get_first_child ();
        var id_label = (Gtk.Label) name_label.get_next_sibling ();

        name_label.label = @"$(item_data.name)";
        id_label.label = @"ID: $(item_data.id)";
    }

    private void on_list_view_header_setup (Gtk.SignalListItemFactory factory, GLib.Object list_header_obj) {
        var header_label = new Gtk.Label ("");
        header_label.halign = Gtk.Align.START;
        ((Gtk.ListHeader) list_header_obj).child = header_label;
    }

    private void on_list_view_header_bind (Gtk.SignalListItemFactory factory, GLib.Object list_header_obj) {
        var list_header = (Gtk.ListHeader) list_header_obj;
        var header_label = (Gtk.Label) list_header.child;
        header_label.label = "Customers";
    }


    
}
