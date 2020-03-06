class SelectionUtilisateur < Gtk::ScrolledWindow

	def initialize(utilisateurs)
		super()
		self.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
		self.expand = true

		grid = Gtk::Grid.new()
		grid.row_spacing = 20
		grid.column_spacing = 20
		grid.margin = 5

                x = 0
                y = 0

                utilisateurs.each() do |u|
                    l = Gtk::Button.new(label: u)
                    #l.expand = true
                    l.signal_connect("clicked") { |widget| puts("Connexion de #{u}") }
                    grid.attach(l, x, y, 1, 1)
                    x += 1
                    if y > 2
                        y += 1
                        x = 0
                    end
                end

		self.add(grid)
	end
end