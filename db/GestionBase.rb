#Fonction de gestion de la base de données
require "rubygems"
require "active_record"
require_relative "Joue"
require_relative "Joueur"
require_relative "GrilleDb"
require_relative "Difficulte"
require_relative "Mode"
require_relative "PhrasesAventure"

# Classe permettant la récupérations d'informations de la Base de données vers le programme grâce au joueur ou aux grilles
class GestionBase
	# Ajoute un joueur à la base de donnée
	#
	# === Paramètres
	#
	# * +pseudo+ => Le pseudo que le joueur désire (chaîne de caractères)
	#
	# === Retour
	#
	# Vrai si le pseudo est libre, faux si déjà utilisé
	#
	def GestionBase.ajouterJoueur(pseudo)
		retour = nil
	
		#Si le pseudo n'est pas déjà pris
		if(recupJoueur(pseudo)==nil)
			retour = Joueur.create( :pseudo => pseudo)
		end
	
		return retour != nil
	end
	
	# Récupère un joueur de la base de donnée via son pseudo
	#
	# === Paramètres
	#
	# * +pseudo+ => Le pseudo du joueur que l'on souhaite récupérer (chaîne de caractères)
	#
	# === Retour
	#
	# Le joueur si existant, nil sinon
	#
	def GestionBase.recupJoueur(pseudo)
		return Joueur.find_by_pseudo(pseudo)
	end
	
	# Récupère la difficulté d'une grille via son Id
	#
	# === Paramètres
	#
	# * +idGrille+ => L'Id de la grille dont on veut récupérer la difficulté
	#
	# === Retour
	#
	# La difficulté (niveau) de la grille (chaîne de caractère), ou nil si impossible à trouver
	#
	def GestionBase.recupDifficulte(idGrille)
		grille= GrilleDb.find(idGrille)
		return Difficulte.find(grille.difficultes_id).niveau
	end
	
	# Récupère le mode de jeu de la grille via son Id
	#
	# === Paramètres
	#
	# * +idGrille+ => L'Id de la grille dont on veut récupérer le mode de jeu
	#
	# === Retour
	#
	# Le mode de jeu de la grille (chaîne de caractère), ou nil si impossible à trouver
	#
	def GestionBase.recupMode(idGrille)
		grille= GrilleDb.find(idGrille)
		return Mode.find(grille.modes_id).mode_jeu
	end
	
	# Récupère le score total du joueur sur les grilles qu'il a joué (uniquement en mode classé)
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du joueur dont on veut récupérer le score total
	#
	# === Retour
	#
	# Le score total du joueur, ou nil si le joueur n'existe pas
	#
	def GestionBase.recupScoreTotal(idJoueur)
		score = nil
	
		begin
			Joueur.find(idJoueur)
			grilles = Joue.where([ "joueurs_id = ?", idJoueur ]).select{ |joue| recupMode(GrilleDb.find(joue.grille_dbs_id).id).mode_jeu == "Classe"}
			score = grilles.inject(0) { |score, joue| score += joue.score }
	
		rescue
			puts "recupScoreTotal ==> Joueur d'id #{idJoueur} n'existe pas dans la base"
		ensure
			return score
		end
	#	return Joue.where([ "joueurs_id = ?", idJoueur ]).sum(:score)
	end
	
	# Récupère le nombre de grilles jouées par le joueur (uniquement en mode classé)
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du joueur dont on veut récupérer le nombre de grilles jouées
	#
	# === Retour
	#
	# Le nombre de grilles jouées par le joueur, ou nil si le joueur n'existe pas
	#
	def GestionBase.recupNbGrillesJouees(idJoueur)
		nb = nil
	
		begin
			Joueur.find(idJoueur)
			grilles = Joue.where([ "joueurs_id = ?", idJoueur ]).select{ |joue| recupMode(GrilleDb.find(joue.grille_dbs_id).id).mode_jeu == "Classe"}
			nb = grilles.inject(0) { |nb, joue| nb += 1 }
		rescue
			puts "recupNbGrillesJouees ==> Joueur d'id #{idJoueur} n'existe pas dans la base"
		ensure
			return nb
		end
	#	return Joue.where([ "joueurs_id = ?", idJoueur ]).count
	end
	
	# Sauvegarde la grilles jouée par le joueur ou la créée si elle n'existe pas
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du joueur dont on veut récupérer la grille déjà commencées
	# * +grilleDb+ => L'objet grille à enregistrer
	#
	# === Retour
	#
	# Aucun retour (Enregistrement dans la base)
	#
	def GestionBase.sauvegarderGrille(idJoueur, grilleDb)
		begin			
			raise ("raise sauvegarderGrille") if ((joue=Joue.where([ "joueurs_id = ? AND grille_dbs_id = ?", idJoueur, grilleDb.id ])).count != 1)
			
		rescue
			Joue.create( :joueurs_id => idJoueur, :grille_dbs_id => grilleDb.id)
		end
	end
	
	# Récupère les grilles jouées par le joueur
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du joueur dont on veut récupérer les grilles déjà commencées 
	#
	# === Retour
	#
	# Les grilles jouées par le joueur, ou nil si le joueur n'existe pas
	#
	def GestionBase.recupGrilles(idJoueur)
		grilles = nil
	
		begin
			Joueur.find(idJoueur)
			grilles = Array.new #GrilleDb.all
#			joue = Joue.where([ "joueurs_id = ?", idJoueur ])
			begin
				GrilleDb.all.each do |grilleDb|
#puts grille.id
#joue = nil
					begin
						joue = Joue.where([ "joueurs_id = ? AND grille_dbs_id = ?", idJoueur, grilleDb.id ])
					rescue
						joue = nil
					end
#joue.each { |j| puts "Joue: #{j}" }
					if (joue != nil && !joue.empty?)
p joue
						grilles.push(joue.grilleSer)
					else
#						grille = grilleDb.grilleSolution
#						grilleDb.grilleSolution = YAML.load(grilleDb.grilleSolution)
						grille = grilleDb.grilleSolution
#puts "Joue:  #{joue == nil}"
#p grille
						grille = YAML.load(grille)
#p grille
						grille.tabLien.each { |lien| grille.supprimerLien(lien) }
						grilleDb.grilleSolution = YAML.dump(grille)
						grilles.push(grilleDb)
					end					
				end
				joue.map { |joue| grilles.push(GrilleDb.find(joue.grille_dbs_id)) }
			rescue
				puts "recupGrilles ==> Problème récupération grille depuis joue"
			end
		rescue
			puts "recupGrilles ==> Joueur d'id #{idJoueur} n'existe pas dans la base"
		ensure
			return grilles
		end
	end

	# Modifie le score de la grille d'un Joueur
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du Joueur dont on veut modifier le scre de l'une des grilles
	# * +idGrilleDb+ => L'objet grille dont on veut modifier le score
	# * +score+ => Le score du Joueur sur la grille en question
	#
	# === Retour
	#
	# Aucun : modifie le score de la grille du joueur
	#
	def GestionBase.changeScore(idJoueur, idGrilleDb, score)

		begin			
			raise ("raise changerScore") if ((joue=Joue.where([ "joueurs_id = ? AND grille_dbs_id = ?", idJoueur, idGrilleDb ])).count != 1)
			joue.update(score: score)
		rescue
			puts "changeScore ==> La grille d'id #{idGrilleDb} du joueur d'id #{idJoueur} n'existe pas dans la base"
		end
	end
end
