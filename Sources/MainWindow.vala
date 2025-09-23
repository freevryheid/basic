
public class Inventory : GLib.Object {
    public string name { get; set; }
    public string desc { get; set; }
    public int id { get; set; }

    public Inventory (string name, string desc, int id) {
        Object (
            name: name,
            desc: desc,
            id: id
        );
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

        inventory.append (new Inventory("Linus", "Legend", "1991"));
        inventory.append (new Inventory("John", "Smith", "1992"));
        inventory.append (new Inventory("Alice", "Key", "1993"));
        inventory.append (new Inventory("Bob", "Key", "1994"));
        inventory.append (new Inventory("Jane", "Doe", "1995"));
        inventory.append (new Inventory("Gabe", "Goode", "1996"));

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

        var sidebar = new Gtk.StackSidebar ();
        sidebar.set_stack (stack);
        //
        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        box.append (sidebar);
        box.append (stack);
        

        this.child = box;
    }
}
