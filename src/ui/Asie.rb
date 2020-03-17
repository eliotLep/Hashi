require "gtk3"
require_relative "Carte"
require_relative "Etiquette"

# Widget Gtk affichant l'asie
class Asie < Carte

    # @factZoom => Facteur de zoom
    # @dX => Décalage de l'affichage en x
    # @dY => Décalage de l'affichage en y

    private

    # Constructeur
    #
    # === Paramètres
    #
    # * +carte+ - Carte principale
    def initialize(carte)
        super(carte)
        @dX = -3450
        @dY = -1650
        @factZoom = 1.0
        res=SerGrille.deserialise(8, "m")
        g = Grille.creer(res.tabCase,res.hauteur,res.largeur, nil)
        ajouterEtiquette(Etiquette.new(3700, 1600, 90, 30, 1, g))
        ajouterEtiquette(Etiquette.new(3200, 1570, 90, 30, 2, g))
        ajouterEtiquette(Etiquette.new(3500, 1700, 90, 30, 3, g))
        ajouterEtiquette(Etiquette.new(3100, 1800, 90, 30, 0, g))
        ajouterEtiquette(Etiquette.new(3340, 1860, 90, 30, 3, g))
        ajouterEtiquette(Etiquette.new(3500, 1500, 90, 30, 1, g))
        ajouterEtiquette(Etiquette.new(3500, 2000, 90, 30, 3, g))
        dessinerEtiquettes()
    end
end
