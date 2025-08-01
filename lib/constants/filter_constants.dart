import 'package:icar_instagram_ui/models/subcategory_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class FilterConstants {
  // Spare parts categories
  // Categories
  static const List<Map<String, String>> sparePartsCategories = [
    {
      'id': '1',
      'name': 'Amortissement',
      'image': 'assets/images/categoryImages/Amortissement.png',
    },
    {
      'id': '2',
      'name': 'Arbres De Transmission et Différentiels',
      'image':
          'assets/images/categoryImages/Arbres_De_Transmission_et_Différentiels.png',
    },
    {
      'id': '3',
      'name': 'Boîte de vitesses',
      'image': 'assets/images/categoryImages/Boîte_de_vitesses.png',
    },
    {
      'id': '4',
      'name': 'Capteurs, Relais, Unités De Commande',
      'image':
          'assets/images/categoryImages/Capteurs,_Relais,_Unités_De_Commande.png',
    },
    {
      'id': '5',
      'name': 'Cardan De Transmission et Joint Homocinétique',
      'image':
          'assets/images/categoryImages/Cardan_De_Transmission_et_Joint_Homocinétique.png',
    },
    {
      'id': '6',
      'name': 'Carrosserie',
      'image': 'assets/images/categoryImages/Carrosserie.png',
    },
    {
      'id': '7',
      'name': 'Chauffage Ventilation',
      'image': 'assets/images/categoryImages/Chauffage_-_Ventilation.png',
    },
    {
      'id': '8',
      'name': 'Climatisation',
      'image': 'assets/images/categoryImages/Climatisation.png',
    },
    {
      'id': '9',
      'name': 'Courroies, Chaînes, Galets',
      'image': 'assets/images/categoryImages/Courroies,_Chaînes,_Galets.png',
    },
    {
      'id': '10',
      'name': 'Direction',
      'image': 'assets/images/categoryImages/Direction.png',
    },
    {
      'id': '11',
      'name': 'Dispositif d\'attelage accessoires',
      'image':
          'assets/images/categoryImages/Dispositif_d\'attelage_-accessoires.png',
    },
    {
      'id': '12',
      'name': 'Echappement',
      'image': 'assets/images/categoryImages/Echappement.png',
    },
    {
      'id': '13',
      'name': 'Eclairage',
      'image': 'assets/images/categoryImages/Eclairage.png',
    },
    {
      'id': '14',
      'name': 'Embrayage composants',
      'image': 'assets/images/categoryImages/Embrayage_-_composants.png',
    },
    {
      'id': '15',
      'name': 'Filtre',
      'image': 'assets/images/categoryImages/Filtre.png',
    },
    {
      'id': '16',
      'name': 'Freinage',
      'image': 'assets/images/categoryImages/Freinage.png',
    },
    {
      'id': '17',
      'name': 'Intérieur et Confort',
      'image': 'assets/images/categoryImages/Intérieur_et_Confort.png',
    },
    {
      'id': '18',
      'name': 'Joints et_Rondelles d\'Étanchéité',
      'image':
          'assets/images/categoryImages/Joints_et_Rondelles_d\'Étanchéité.png',
    },
    {
      'id': '19',
      'name': 'Kits De Réparation',
      'image': 'assets/images/categoryImages/Kits_De_Réparation.png',
    },
    {
      'id': '20',
      'name': 'Moteur',
      'image': 'assets/images/categoryImages/Moteur.png',
    },
    {
      'id': '21',
      'name': 'Nettoyage des vitres',
      'image': 'assets/images/categoryImages/Nettoyage_des_vitres.png',
    },
    {
      'id': '22',
      'name': 'Pneus et produits associés',
      'image': 'assets/images/categoryImages/Pneus_et_produits_associés.png',
    },
    {
      'id': '23',
      'name': 'Recirculation des_gaz d\'échappement',
      'image':
          'assets/images/categoryImages/Recirculation_des_gaz_d\'échappement.png',
    },
    {
      'id': '24',
      'name': 'Refroidissement Moteur',
      'image': 'assets/images/categoryImages/Refroidissement_Moteur.png',
    },
    {
      'id': '25',
      'name': 'Roulements',
      'image': 'assets/images/categoryImages/Roulements.png',
    },
    {
      'id': '26',
      'name': 'Suspension et Bras',
      'image': 'assets/images/categoryImages/Suspension_et_Bras.png',
    },
    {
      'id': '27',
      'name': 'Suspension pneumatique',
      'image': 'assets/images/categoryImages/Suspension_pneumatique.png',
    },
    {
      'id': '28',
      'name': 'Système d\'Alimentation',
      'image': 'assets/images/categoryImages/Système_d\'Alimentation.png',
    },
    {
      'id': '29',
      'name': 'Système d\'Allumage et Bougies de Préchauffage',
      'image':
          'assets/images/categoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage.png',
    },
    {
      'id': '30',
      'name': 'Système électrique',
      'image': 'assets/images/categoryImages/Système_électrique.png',
    },
    {
      'id': '31',
      'name': 'Tuning',
      'image': 'assets/images/categoryImages/Tuning.png',
    },
    {
      'id': '32',
      'name': 'Turbocompresseur',
      'image': 'assets/images/categoryImages/Turbocompresseur.png',
    },
    {
      'id': '33',
      'name': 'Tuyaux et Conduites',
      'image': 'assets/images/categoryImages/Tuyaux_et_Conduites.png',
    },
    {
      'id': '34',
      'name': 'Éléments de fixation',
      'image': 'assets/images/categoryImages/Éléments_de_fixation.png',
    },
  ];

  // Subcategories
  static List<Subcategory> getSubcategories(String categoryId) {
    try {
      switch (categoryId) {
        case '1': // Amortissement
          return [
            Subcategory(
              id: '1-1',
              name: 'Accumulateur de Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Accumulateur_de_Suspension.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-2',
              name: 'Amortisseurs',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Amortisseurs.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-3',
              name: 'Compresseur Systeme D\'Air Comprimé D\'Admission Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Compresseur_Systeme_D\'Air_Comprimé_D\'Admission_Moteur.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-4',
              name: 'Coupelle d\'Amortisseur',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Coupelle_d\'Amortisseur.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-5',
              name: 'Huile Hydraulique',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Huile_Hydraulique.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-6',
              name: 'Jeu de Suspensions Ressorts Amortisseurs',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Jeu_de_Suspensions_Ressorts_Amortisseurs.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-7',
              name: 'Kit Réparation Suspension De Roue',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Kit_Réparation_Suspension_De_Roue.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-8',
              name: 'Kit de Ressorts',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Kit_de_Ressorts.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-9',
              name: 'Lame De Ressort',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Lame_De_Ressort.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-10',
              name: 'Outils pour amortisseurs ressorts',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Outils_pour_amortisseurs_ressorts.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-11',
              name: 'Patin de ressort',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Patin_de_ressort.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-12',
              name: 'Ressort d\'Amortisseur',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Ressort_d\'Amortisseur.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-13',
              name: 'Ressort pneumatique',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Ressort_pneumatique.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-14',
              name: 'Soufflet d\'Amortisseur & Butée Élastique Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Soufflet_d\'Amortisseur_&_Butée_Élastique_Suspension.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-15',
              name: 'Soufflet À Air Suspension Pneumatique',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Soufflet_À_Air_Suspension_Pneumatique.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-16',
              name: 'Support Amortisseur',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Support_Amortisseur.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-17',
              name: 'Suspension amortisseur',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Suspension_amortisseur.png',
              categoryId: '1',
            ),
            Subcategory(
              id: '1-18',
              name: 'Vis de correction des chutes',
              imagePath:
                  'assets/images/subcategoryImages/Amortissement/Vis_de_correction_des_chutes.png',
              categoryId: '1',
            ),
          ];

        case '2': // Arbres De Transmission et Différentiels
          return [
            Subcategory(
              id: '2-1',
              name: 'Arbre De Transmission',
              imagePath:
                  'assets/images/subcategoryImages/Arbres_De_Transmission_et_Différentiels/Arbre_De_Transmission.png',
              categoryId: '2',
            ),
            Subcategory(
              id: '2-2',
              name: 'Bague D\'Étanchéité De Différentiel',
              imagePath:
                  'assets/images/subcategoryImages/Arbres_De_Transmission_et_Différentiels/Bague_D\'Étanchéité_De_Différentiel.png',
              categoryId: '2',
            ),
            Subcategory(
              id: '2-3',
              name: 'Bague d\'étanchéité casier de transfert',
              imagePath:
                  'assets/images/subcategoryImages/Arbres_De_Transmission_et_Différentiels/Bague_d\'étanchéité_casier_de_transfert.png',
              categoryId: '2',
            ),
            Subcategory(
              id: '2-4',
              name: 'Composantes Différentielle',
              imagePath:
                  'assets/images/subcategoryImages/Arbres_De_Transmission_et_Différentiels/Composantes_Différentielle.png',
              categoryId: '2',
            ),
            Subcategory(
              id: '2-5',
              name: 'Douille De Centrage D\'Arbre Longitudinal',
              imagePath:
                  'assets/images/subcategoryImages/Arbres_De_Transmission_et_Différentiels/Douille_De_Centrage_D\'Arbre_Longitudinal.png',
              categoryId: '2',
            ),
            Subcategory(
              id: '2-6',
              name: 'Flector De Transmission',
              imagePath:
                  'assets/images/subcategoryImages/Arbres_De_Transmission_et_Différentiels/Flector_De_Transmission.png',
              categoryId: '2',
            ),
            Subcategory(
              id: '2-7',
              name: 'Huile Boite Automatique',
              imagePath:
                  'assets/images/subcategoryImages/Arbres_De_Transmission_et_Différentiels/Huile_Boite_Automatique.png',
              categoryId: '2',
            ),
            Subcategory(
              id: '2-8',
              name: 'Huile De Transmission et Huile Boite De Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Arbres_De_Transmission_et_Différentiels/Huile_De_Transmission_et_Huile_Boite_De_Vitesse.png',
              categoryId: '2',
            ),
            Subcategory(
              id: '2-9',
              name: 'Kit de réparation différentiel',
              imagePath:
                  'assets/images/subcategoryImages/Arbres_De_Transmission_et_Différentiels/Kit_de_réparation_différentiel.png',
              categoryId: '2',
            ),
            Subcategory(
              id: '2-10',
              name: 'Silent Bloc De Boîte De Transfert',
              imagePath:
                  'assets/images/subcategoryImages/Arbres_De_Transmission_et_Différentiels/Silent_Bloc_De_Boîte_De_Transfert.png',
              categoryId: '2',
            ),
            Subcategory(
              id: '2-11',
              name: 'Suspension Arbre De Cardan',
              imagePath:
                  'assets/images/subcategoryImages/Arbres_De_Transmission_et_Différentiels/Suspension_Arbre_De_Cardan.png',
              categoryId: '2',
            ),
          ];

        case '3': // Boîte de vitesses
          return [
            Subcategory(
              id: '3-1',
              name: 'Appareil de commande transmission automatique',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Appareil_de_commande_transmission_automatique.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-2',
              name: 'Capteur Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Capteur_Vitesse.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-3',
              name: 'Carter d\'Huile Boîte Automatique',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Carter_d\'Huile_Boîte_Automatique.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-4',
              name: 'Composants Pommeau Boite De Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Composants_Pommeau_Boite_De_Vitesse.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-5',
              name: 'Composants boite de vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Composants_boite_de_vitesse.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-6',
              name: 'Contacteur de Feu de Recul',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Contacteur_de_Feu_de_Recul.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-7',
              name: 'Couvercle de flasque boîte de vitesse manuelle',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Couvercle_de_flasque_boîte_de_vitesse_manuelle.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-8',
              name: 'Filtre de Boite Automatique',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Filtre_de_Boite_Automatique.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-9',
              name: 'Huile Boite Automatique',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Huile_Boite_Automatique.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-10',
              name: 'Huile De Transmission et Huile Boite De Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Huile_De_Transmission_et_Huile_Boite_De_Vitesse.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-11',
              name: 'Jeu de pièces Vidange boîte automatique',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Jeu_de_pièces_Vidange_boîte_automatique.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-12',
              name: 'Joint Boite de Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Joint_Boite_de_Vitesse.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-13',
              name: 'Joint Carte D\'Huile Boite À Vitesses Automatique',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Joint_Carte_D\'Huile_Boite_À_Vitesses_Automatique.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-14',
              name: 'Kit Réparation Levier Changement De Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Kit_Réparation_Levier_Changement_De_Vitesse.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-15',
              name: 'Kit de Réparation Levier de Changement de Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Kit_de_Réparation_Levier_de_Changement_de_Vitesse.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-16',
              name: 'Kit de réparation flasque de boîte de vitesse manuelle',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Kit_de_réparation_flasque_de_boîte_de_vitesse_manuelle.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-17',
              name: 'Radiateur d\'Huile De Boite De Vitesse Automatique',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Radiateur_d\'Huile_De_Boite_De_Vitesse_Automatique.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-18',
              name: 'Silent Bloc De Boîte De Transfert',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Silent_Bloc_De_Boîte_De_Transfert.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-19',
              name: 'Support De Boite De Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Support_De_Boite_De_Vitesse.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-20',
              name: 'Suspension Boîte Manuelle',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Suspension_Boîte_Manuelle.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-21',
              name: 'Tringlerie de boite de vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Tringlerie_de_boite_de_vitesse.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-22',
              name: 'Valve de commande transmission automatique',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Valve_de_commande_transmission_automatique.png',
              categoryId: '3',
            ),
            Subcategory(
              id: '3-23',
              name: 'Volant Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Boîte_de_vitesses/Volant_Moteur.png',
              categoryId: '3',
            ),
          ];

        case '4': // Capteurs Relais Unités De Commande
          return [
            Subcategory(
              id: '4-1',
              name: 'Appareil de commande chauffage ventilation',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Appareil_de_commande_chauffage_ventilation.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-2',
              name: 'Appareil de commande gestion moteur',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Appareil_de_commande_gestion_moteur.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-3',
              name: 'Appareil de commande système d\'éclairage',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Appareil_de_commande_système_d\'éclairage.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-4',
              name: 'Appareil de commande verrouillage central',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Appareil_de_commande_verrouillage_central.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-5',
              name: 'Bague Abs',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Bague_Abs.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-6',
              name: 'Capteur ABS',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_ABS.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-7',
              name: 'Capteur Aac',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_Aac.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-8',
              name: 'Capteur Correcteur D\'Assiette Phare',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_Correcteur_D\'Assiette_Phare.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-9',
              name: 'Capteur De Cliquetis',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_De_Cliquetis.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-10',
              name: 'Capteur De Niveau De Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_De_Niveau_De_Carburant.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-11',
              name: 'Capteur De Position Du Papillon',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_De_Position_Du_Papillon.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-12',
              name: 'Capteur Niveau Liquide De Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_Niveau_Liquide_De_Refroidissement.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-13',
              name: 'Capteur Niveau d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_Niveau_d\'Huile.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-14',
              name: 'Capteur PMH',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_PMH.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-15',
              name: 'Capteur Pression D\'Admission',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_Pression_D\'Admission.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-16',
              name: 'Capteur Température Intérieur',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_Température_Intérieur.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-17',
              name: 'Capteur Température de L\'air d\'Admission',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_Température_de_L\'air_d\'Admission.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-18',
              name: 'Capteur Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_Vitesse.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-19',
              name: 'Capteur de Pression Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_de_Pression_Carburant.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-20',
              name: 'Capteur de Pression Différentielle',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_de_Pression_Différentielle.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-21',
              name: 'Capteur de Pression de Suralimentation',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_de_Pression_de_Suralimentation.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-22',
              name: 'Capteur de Température d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_de_Température_d\'Huile.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-23',
              name: 'Capteur de Température des Gaz d\'Échappement',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_de_Température_des_Gaz_d\'Échappement.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-24',
              name: 'Capteur niveau de l\'eau de lavage',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_niveau_de_l\'eau_de_lavage.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-25',
              name: 'Capteur qualité de l\'air',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteur_qualité_de_l\'air.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-26',
              name: 'Capteurs de Recul',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Capteurs_de_Recul.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-27',
              name: 'Centrale Clignotant',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Centrale_Clignotant.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-28',
              name: 'Commande ventilateur électrique refroidissement du moteur',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Commande_ventilateur_électrique_refroidissement_du_moteur.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-29',
              name: 'Contacteur De Feux Stop',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Contacteur_De_Feux_Stop.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-30',
              name: 'Contacteur Leve-Vitre',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Contacteur_Leve-Vitre.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-31',
              name: 'Contacteur de Feu de Recul',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Contacteur_de_Feu_de_Recul.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-32',
              name: 'Contrôle De Pression Des Pneumatiques',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Contrôle_De_Pression_Des_Pneumatiques.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-33',
              name: 'Débitmètre d\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Débitmètre_d\'Air.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-34',
              name: 'Détecteur De l\'Angle De Braquage',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Détecteur_De_l\'Angle_De_Braquage.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-35',
              name: 'Electrovanne De Commande Arbre a cames',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Electrovanne_De_Commande_Arbre_a_cames.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-36',
              name: 'Interrupteur Feu De Détresse',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Interrupteur_Feu_De_Détresse.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-37',
              name: 'Interrupteur de Température ventilateur de radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Interrupteur_de_Température_ventilateur_de_radiateur.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-38',
              name: 'Lève-Vitre',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Lève-Vitre.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-39',
              name: 'Pressostat d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Pressostat_d\'Huile.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-40',
              name: 'Pressostat de Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Pressostat_de_Climatisation.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-41',
              name: 'Relais Chasse Du Ventilateur De Radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Relais_Chasse_Du_Ventilateur_De_Radiateur.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-42',
              name: 'Relais Diode Protection Systeme Abs',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Relais_Diode_Protection_Systeme_Abs.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-43',
              name: 'Relais chauffage de vitre arrière',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Relais_chauffage_de_vitre_arrière.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-44',
              name: 'Relais climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Relais_climatisation.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-45',
              name: 'Relais d\'Essuie-Glace',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Relais_d\'Essuie-Glace.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-46',
              name: 'Relais de Pompe à Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Relais_de_Pompe_à_Carburant.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-47',
              name: 'Relais démarreur',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Relais_démarreur.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-48',
              name: 'Relais klaxon avertisseur sonore',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Relais_klaxon_avertisseur_sonore.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-49',
              name: 'Relais verrouillage central',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Relais_verrouillage_central.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-50',
              name: 'Resistance Pulseur d\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Resistance_Pulseur_d\'Air.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-51',
              name: 'Régulateur De Pression Du Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Régulateur_De_Pression_Du_Carburant.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-52',
              name: 'Régulateur d\'Alternateur',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Régulateur_d\'Alternateur.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-53',
              name: 'Régulateur de Ralenti',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Régulateur_de_Ralenti.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-54',
              name: 'Solénoïde De Démarreur',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Solénoïde_De_Démarreur.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-55',
              name: 'Sonde Lambda',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Sonde_Lambda.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-56',
              name: 'Sonde de Température Liquide de Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Sonde_de_Température_Liquide_de_Refroidissement.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-57',
              name: 'Sonde de température',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Sonde_de_température.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-58',
              name: 'Temporisateur de Préchauffage',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Temporisateur_de_Préchauffage.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-59',
              name: 'Témoin d\'Usure Plaquettes De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Témoin_d\'Usure_Plaquettes_De_Frein.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-60',
              name: 'Valve De Réglage Compresseur',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Valve_De_Réglage_Compresseur.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-61',
              name: 'Valvle Contrôle D\'Air -Air Admission',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Valvle_Contrôle_D\'Air_-Air_Admission.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-62',
              name: 'Électrovanne De Turbo',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Électrovanne_De_Turbo.png',
              categoryId: '4',
            ),
            Subcategory(
              id: '4-63',
              name: 'Élément d\'Ajustage Correcteur de Portée Lumineuse',
              imagePath:
                  'assets/images/subcategoryImages/Capteurs_Relais_Unités_De_Commande/Élément_d\'Ajustage_Correcteur_de_Portée_Lumineuse.png',
              categoryId: '4',
            ),
          ];

        case '5': // Cardan De Transmission et Joint Homocinétique
          return [
            Subcategory(
              id: '5-1',
              name: 'Bague d\'étanchéité arbre de transmission',
              imagePath:
                  'assets/images/subcategoryImages/Cardan_De_Transmission_et_Joint_Homocinétique/Bague_d\'étanchéité_arbre_de_transmission.png',
              categoryId: '5',
            ),
            Subcategory(
              id: '5-2',
              name: 'Cardan',
              imagePath:
                  'assets/images/subcategoryImages/Cardan_De_Transmission_et_Joint_Homocinétique/Cardan.png',
              categoryId: '5',
            ),
            Subcategory(
              id: '5-3',
              name: 'Lubrifiants',
              imagePath:
                  'assets/images/subcategoryImages/Cardan_De_Transmission_et_Joint_Homocinétique/Lubrifiants.png',
              categoryId: '5',
            ),
            Subcategory(
              id: '5-4',
              name: 'Palier - Relais Arbre Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Cardan_De_Transmission_et_Joint_Homocinétique/Palier_-_Relais_Arbre_Moteur.png',
              categoryId: '5',
            ),
            Subcategory(
              id: '5-5',
              name: 'Pâte d\'assemblage',
              imagePath:
                  'assets/images/subcategoryImages/Cardan_De_Transmission_et_Joint_Homocinétique/Pâte_d\'assemblage.png',
              categoryId: '5',
            ),
            Subcategory(
              id: '5-6',
              name: 'Soufflet de Cardan',
              imagePath:
                  'assets/images/subcategoryImages/Cardan_De_Transmission_et_Joint_Homocinétique/Soufflet_de_Cardan.png',
              categoryId: '5',
            ),
            Subcategory(
              id: '5-7',
              name: 'Tripode',
              imagePath:
                  'assets/images/subcategoryImages/Cardan_De_Transmission_et_Joint_Homocinétique/Tripode.png',
              categoryId: '5',
            ),
            Subcategory(
              id: '5-8',
              name: 'Tête de Cardan',
              imagePath:
                  'assets/images/subcategoryImages/Cardan_De_Transmission_et_Joint_Homocinétique/Tête_de_Cardan.png',
              categoryId: '5',
            ),
            Subcategory(
              id: '5-9',
              name: 'Vis Flasque D\'Arbre De Cardan',
              imagePath:
                  'assets/images/subcategoryImages/Cardan_De_Transmission_et_Joint_Homocinétique/Vis_Flasque_D\'Arbre_De_Cardan.png',
              categoryId: '5',
            ),
            Subcategory(
              id: '5-10',
              name: 'Écrou bout d\'essieu',
              imagePath:
                  'assets/images/subcategoryImages/Cardan_De_Transmission_et_Joint_Homocinétique/Écrou_bout_d\'essieu.png',
              categoryId: '5',
            ),
          ];

        case '6': // Carrosserie
          return [
            Subcategory(
              id: '6-1',
              name: 'Adhésifs verre automobile et pare-brise',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Adhésifs_verre_automobile_et_pare-brise.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-2',
              name: 'Aile',
              imagePath: 'assets/images/subcategoryImages/Carrosserie/Aile.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-3',
              name: 'Ampoule De Feu Clignotant',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Ampoule_De_.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-4',
              name: 'Ampoule Feu Eclaireur De Plaque',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Ampoule_Feu_Eclaireur_De_Plaque.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-5',
              name: 'Ampoule Pour Feux Arrières',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Ampoule_Pour_Feux_Arrières.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-6',
              name: 'Ampoule Pour Projecteur Antibrouillard',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Ampoule_Pour_Projecteur_Antibrouillard.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-7',
              name: 'Ampoule Pour Projecteur Principal',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Ampoule_Pour_Projecteur_Principal.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-8',
              name: 'Ampoule Projecteur Longue Portée',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Ampoule_Projecteur_Longue_Portée.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-9',
              name: 'Ampoules Pour Feux De Stop',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Ampoules_Pour_Feux_De_Stop.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-10',
              name: 'Anti-brouillard',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Anti-brouillard.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-11',
              name: 'Anti-gravillons',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Anti-gravillons.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-12',
              name: 'Antibrouillard Arriere',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Antibrouillard_Arriere.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-13',
              name: 'Apprêt',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Apprêt.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-14',
              name: 'Apprêts pour peinture automobile',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Apprêts_pour_peinture_automobile.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-15',
              name: 'Baguette',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Baguette.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-16',
              name: 'Bandeau Pare-Choc',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Bandeau_Pare-Choc.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-17',
              name: 'Bas de Caisse',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Bas_de_Caisse.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-18',
              name: 'Cache Crochet De Remorquage',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Cache_Crochet_De_Remorquage.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-19',
              name: 'Cache Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Cache_Moteur.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-20',
              name: 'Cadre de montant de toit cadre de montant de porte',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Cadre_de_montant_de_toit_cadre_de_montant_de_porte.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-21',
              name: 'Capot',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Capot.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-22',
              name: 'Capteurs de Recul',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Capteurs_de_Recul.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-23',
              name: 'Carter De Protection Sous Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Carter_De_Protection_Sous_Moteur.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-24',
              name: 'Catadioptre Arrière',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Catadioptre_Arrière.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-25',
              name: 'Cire pour cavités',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Cire_pour_cavités.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-26',
              name: 'Clignotant',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Clignotant.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-27',
              name: 'Colles plastique',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Colles_plastique.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-28',
              name: 'Composants De Feu Arrière',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Composants_De_Feu_Arrière.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-29',
              name: 'Composants Des Projecteurs Principaux',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Composants_Des_Projecteurs_Principaux.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-30',
              name: 'Composants Pour Projecteur Antibrouillard',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Composants_Pour_Projecteur_Antibrouillard.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-31',
              name: 'Convertisseurs de rouille',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Convertisseurs_de_rouille.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-32',
              name: 'Coque de Rétroviseur',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Coque_de_Rétroviseur.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-33',
              name: 'Cylindre de Serrure',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Cylindre_de_Serrure.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-34',
              name: 'Diluants',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Diluants.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-35',
              name: 'Durcisseurs de peinture',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Durcisseurs_de_peinture.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-36',
              name: 'Eclairage De Plaque d\'Immatriculation',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Eclairage_De_Plaque_d\'Immatriculation.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-37',
              name: 'Elargisseur d\'Aile',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Elargisseur_d\'Aile.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-38',
              name: 'Emblèmes',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Emblèmes.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-39',
              name: 'Enjoliveur Projecteur Antibrouillard',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Enjoliveur_Projecteur_Antibrouillard.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-40',
              name: 'Extension d\'aile',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Extension_d\'aile.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-41',
              name: 'Face Avant',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Face_Avant.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-42',
              name: 'Fermeture Centralisée',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Fermeture_Centralisée.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-43',
              name: 'Feu Arrière',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Feu_Arrière.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-44',
              name: 'Feu De Recul',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Feu_De_Recul.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-45',
              name: 'Feu De Stop',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Feu_De_Stop.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-46',
              name: 'Feu Diurne',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Feu_Diurne.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-47',
              name: 'Feu Stop Additionnel',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Feu_Stop_Additionnel.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-48',
              name: 'Feu clignotant latéral',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Feu_clignotant_latéral.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-49',
              name: 'Feu de Position',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Feu_de_Position.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-50',
              name: 'Fixation Cric',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Fixation_Cric.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-51',
              name: 'Fixation de radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Fixation_de_radiateur.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-52',
              name: 'Glace Rétroviseur',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Glace_Rétroviseur.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-53',
              name: 'Grille de Calandre',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Grille_de_Calandre.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-54',
              name: 'Grille de Pare-Chocs',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Grille_de_Pare-Chocs.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-55',
              name: 'Hayon de Coffre',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Hayon_de_Coffre.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-56',
              name: 'Insonorisant Du Compartiment Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Insonorisant_Du_Compartiment_Moteur.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-57',
              name: 'Interrupteur D\'Allumage De Démarreur',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Interrupteur_D\'Allumage_De_Démarreur.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-58',
              name: 'Joint De Pare Brise',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Joint_De_Pare_Brise.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-59',
              name: 'Joint d\'étanchéité de porte',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Joint_d\'étanchéité_de_porte.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-60',
              name: 'Joint d\'étanchéité toit ouvrant',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Joint_d\'étanchéité_toit_ouvrant.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-61',
              name: 'Joint feu arrière',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Joint_feu_arrière.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-62',
              name: 'Laques',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Laques.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-63',
              name: 'Longeron',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Longeron.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-64',
              name: 'Lunette arrière',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Lunette_arrière.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-65',
              name: 'Mastics pour carrosserie automobile',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Mastics_pour_carrosserie_automobile.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-66',
              name: 'Panneau Latéral',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Panneau_Latéral.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-67',
              name: 'Pare-Boue',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Pare-Boue.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-68',
              name: 'Pare-Chocs',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Pare-Chocs.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-69',
              name: 'Pare-brise',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Pare-brise.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-70',
              name: 'Peintures automobiles',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Peintures_automobiles.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-71',
              name: 'Peintures pour pare-chocs',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Peintures_pour_pare-chocs.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-72',
              name: 'Peintures à pulvériser de couleur ral',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Peintures_à_pulvériser_de_couleur_ral.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-73',
              name: 'Phare Avant',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Phare_Avant.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-74',
              name: 'Phares Au Xénon',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Phares_Au_Xénon.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-75',
              name: 'Plancher de carrosserie',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Plancher_de_carrosserie.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-76',
              name: 'Poignée De Porte',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Poignée_De_Porte.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-77',
              name: 'Portes Composants',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Portes_Composants.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-78',
              name: 'Produits d\'étanchéité pare-brise et verre',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Produits_d\'étanchéité_pare-brise_et_verre.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-79',
              name: 'Produits de lavage de voiture et soins extérieurs',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Produits_de_lavage_de_voiture_et_soins_extérieurs.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-80',
              name: 'Produits dégraissants puissants',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Produits_dégraissants_puissants.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-81',
              name: 'Renfort de Pare-Chocs',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Renfort_de_Pare-Chocs.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-82',
              name: 'Ressort pneumatique capote',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Ressort_pneumatique_capote.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-83',
              name: 'Revêtement arrière',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Revêtement_arrière.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-84',
              name: 'Réservoir de Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Réservoir_de_Carburant.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-85',
              name: 'Rétroviseur',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Rétroviseur.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-86',
              name: 'Scellants de joints de carrosserie',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Scellants_de_joints_de_carrosserie.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-87',
              name: 'Serrure De Porte',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Serrure_De_Porte.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-88',
              name: 'Serrure de hayon',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Serrure_de_hayon.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-89',
              name: 'Soupape De Ventilation De Réservoir Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Soupape_De_Ventilation_De_Réservoir_Carburant.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-90',
              name: 'Support capteur-parctronic',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Support_capteur-parctronic.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-91',
              name: 'Support de Pare-Chocs',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Support_de_Pare-Chocs.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-92',
              name: 'Support de batterie',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Support_de_batterie.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-93',
              name: 'Support et plaque d\'immatriculation',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Support_et_plaque_d\'immatriculation.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-94',
              name: 'Train Arriere',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Train_Arriere.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-95',
              name: 'Traitement antirouille',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Traitement_antirouille.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-96',
              name: 'Verin De Hayon',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Verin_De_Hayon.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-97',
              name: 'Verin de Capot',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Verin_de_Capot.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-98',
              name: 'Verre de phare',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Verre_de_phare.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-99',
              name: 'Vitres',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Vitres.png',
              categoryId: '6',
            ),
            Subcategory(
              id: '6-100',
              name: 'Éponges lingettes et brosses',
              imagePath:
                  'assets/images/subcategoryImages/Carrosserie/Éponges_lingettes_et_brosses.png',
              categoryId: '6',
            ),
          ];

        case '7': // Chauffage  Ventilation
          return [
            Subcategory(
              id: '7-1',
              name: 'Appareil de commande chauffage ventilation',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Appareil_de_commande_chauffage_ventilation.png',
              categoryId: '7',
            ),
            Subcategory(
              id: '7-2',
              name: 'Bougie de préchauffage chauffage auxiliaire',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Bougie_de_préchauffage_chauffage_auxiliaire.png',
              categoryId: '7',
            ),
            Subcategory(
              id: '7-3',
              name: 'Capteur Température Intérieur',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Capteur_Température_Intérieur.png',
              categoryId: '7',
            ),
            Subcategory(
              id: '7-4',
              name: 'Filtre d\'Habitacle',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Filtre_d\'Habitacle.png',
              categoryId: '7',
            ),
            Subcategory(
              id: '7-5',
              name: 'Pompe De Circulation d\'Eau Chauffage Auxiliaire',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Pompe_De_Circulation_d\'Eau_Chauffage_Auxiliaire.png',
              categoryId: '7',
            ),
            Subcategory(
              id: '7-6',
              name: 'Préchauffage de l\'eau de refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Préchauffage_de_l\'eau_de_refroidissement.png',
              categoryId: '7',
            ),
            Subcategory(
              id: '7-7',
              name: 'Pulseur d\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Pulseur_d\'Air.png',
              categoryId: '7',
            ),
            Subcategory(
              id: '7-8',
              name: 'Radiateur De Chauffage',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Radiateur_De_Chauffage.png',
              categoryId: '7',
            ),
            Subcategory(
              id: '7-9',
              name: 'Resistance Pulseur d\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Resistance_Pulseur_d\'Air.png',
              categoryId: '7',
            ),
            Subcategory(
              id: '7-10',
              name: 'Sonde Temperature Exterieur',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Sonde_Temperature_Exterieur.png',
              categoryId: '7',
            ),
            Subcategory(
              id: '7-11',
              name: 'Valve magnétique',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Valve_magnétique.png',
              categoryId: '7',
            ),
            Subcategory(
              id: '7-12',
              name: 'Élément d\'ajustage clapet de mélange',
              imagePath:
                  'assets/images/subcategoryImages/Chauffage__Ventilation/Élément_d\'ajustage_clapet_de_mélange.png',
              categoryId: '7',
            ),
          ];

        case '8': // Climatisation
          return [
            Subcategory(
              id: '8-1',
              name: 'Anti fuite air conditionné',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Anti_fuite_air_conditionné.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-2',
              name: 'Appareil de commande climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Appareil_de_commande_climatisation.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-3',
              name: 'Bouteille Déshydratante',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Bouteille_Déshydratante.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-4',
              name: 'Capteur Température Intérieur',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Capteur_Température_Intérieur.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-5',
              name: 'Capteur qualité de l\'air',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Capteur_qualité_de_l\'air.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-6',
              name: 'Commande ventilateur électrique refroidissement du moteur',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Commande_ventilateur_électrique_refroidissement_du_moteur.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-7',
              name: 'Compresseur de Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Compresseur_de_Climatisation.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-8',
              name: 'Condenseur De Clim',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Condenseur_De_Clim.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-9',
              name: 'Conduite de Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Conduite_de_Climatisation.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-10',
              name: 'Détendeur De Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Détendeur_De_Climatisation.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-11',
              name: 'Embrayage Magnétique de Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Embrayage_Magnétique_de_Climatisation.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-12',
              name: 'Evaporateur De Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Evaporateur_De_Climatisation.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-13',
              name: 'Filtre d\'Habitacle',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Filtre_d\'Habitacle.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-14',
              name: 'Interrupteur de Température ventilateur de radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Interrupteur_de_Température_ventilateur_de_radiateur.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-15',
              name: 'Moto Ventilateur De Condenseur De Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Moto_Ventilateur_De_Condenseur_De_Climatisation.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-16',
              name: 'Pressostat de Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Pressostat_de_Climatisation.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-17',
              name: 'Produits de nettoyage d\'air conditionné automobile',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Produits_de_nettoyage_d\'air_conditionné_automobile.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-18',
              name: 'Pulseur d\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Pulseur_d\'Air.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-19',
              name: 'Radiateur De Chauffage',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Radiateur_De_Chauffage.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-20',
              name: 'Relais climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Relais_climatisation.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-21',
              name: 'Resistance Pulseur d\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Resistance_Pulseur_d\'Air.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-22',
              name: 'Sonde Temperature Exterieur',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Sonde_Temperature_Exterieur.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-23',
              name: 'Valve De Réglage Compresseur',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Valve_De_Réglage_Compresseur.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-24',
              name: 'Valve magnétique',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Valve_magnétique.png',
              categoryId: '8',
            ),
            Subcategory(
              id: '8-25',
              name: 'Élément d\'ajustage clapet de mélange',
              imagePath:
                  'assets/images/subcategoryImages/Climatisation/Élément_d\'ajustage_clapet_de_mélange.png',
              categoryId: '8',
            ),
          ];

        case '9': // Courroies Chaînes Galets
          return [
            Subcategory(
              id: '9-1',
              name: 'Amortisseur De Vibrations Courroie De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Amortisseur_De_Vibrations_Courroie_De_Distribution.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-2',
              name:
                  'Amortisseur De Vibrations Courroie Trapézoïdale À Nervures',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Amortisseur_De_Vibrations_Courroie_Trapézoïdale_À_Nervures.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-3',
              name: 'Boulon de poulie',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Boulon_de_poulie.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-4',
              name: 'Carter De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Carter_De_Distribution.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-5',
              name: 'Chaîne De Commande',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Chaîne_De_Commande.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-6',
              name: 'Chaîne De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Chaîne_De_Distribution.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-7',
              name: 'Courroie De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Courroie_De_Distribution.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-8',
              name: 'Courroie Trapézoïdale',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Courroie_Trapézoïdale.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-9',
              name: 'Courroie Trapézoïdale à Nervures',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Courroie_Trapézoïdale_à_Nervures.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-10',
              name: 'Galet Tendeur',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Galet_Tendeur.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-11',
              name: 'Galet Tendeur Courroie Crantée',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Galet_Tendeur_Courroie_Crantée.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-12',
              name: 'Galet enrouleur de courroie d\'accessoire',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Galet_enrouleur_de_courroie_d\'accessoire.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-13',
              name: 'Guide Fixe',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Guide_Fixe.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-14',
              name: 'Jeu De Courroies Trapézoïdales à Nervures',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Jeu_De_Courroies_Trapézoïdales_à_Nervures.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-15',
              name: 'Joint d\'étanchéité tendeur de chaîne de distribution',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Joint_d\'étanchéité_tendeur_de_chaîne_de_distribution.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-16',
              name: 'Kit Chaîne De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Kit_Chaîne_De_Distribution.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-17',
              name: 'Kit De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Kit_De_Distribution.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-18',
              name: 'Manchon flexible d\'accouplement',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Manchon_flexible_d\'accouplement.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-19',
              name: 'Outils pour courroie chaîne',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Outils_pour_courroie_chaîne.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-20',
              name: 'Pompe à Eau',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Pompe_à_Eau.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-21',
              name: 'Pompe à Eau + Kit De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Pompe_à_Eau_+_Kit_De_Distribution.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-22',
              name: 'Poulie-tendeur courroie crantée',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Poulie-tendeur_courroie_crantée.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-23',
              name: 'Poulie-tendeur courroie trapézoïdale',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Poulie-tendeur_courroie_trapézoïdale.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-24',
              name: 'Poulie Damper',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Poulie_Damper.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-25',
              name: 'Poulie courroie de distribution',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Poulie_courroie_de_distribution.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-26',
              name: 'Poulie pompe de direction assistée',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Poulie_pompe_de_direction_assistée.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-27',
              name: 'Poulie renvoi transmission courroie de distribution',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Poulie_renvoi_transmission_courroie_de_distribution.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-28',
              name: 'Tendeur De Chaine De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Tendeur_De_Chaine_De_Distribution.png',
              categoryId: '9',
            ),
            Subcategory(
              id: '9-29',
              name: 'Tendeur de Courroie',
              imagePath:
                  'assets/images/subcategoryImages/Courroies_Chaînes_Galets/Tendeur_de_Courroie.png',
              categoryId: '9',
            ),
          ];

        case '10': // Direction
          return [
            Subcategory(
              id: '10-1',
              name: 'Arbre de direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Arbre_de_direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-2',
              name: 'Barre de direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Barre_de_direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-3',
              name: 'Biellette de direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Biellette_de_direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-4',
              name: 'Colonne De Direction + Direction Assistée Électrique',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Colonne_De_Direction_+_Direction_Assistée_Électrique.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-5',
              name: 'Crémaillère de Direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Crémaillère_de_Direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-6',
              name: 'Douille arbre de levier de direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Douille_arbre_de_levier_de_direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-7',
              name: 'Durite de Direction Assistée',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Durite_de_Direction_Assistée.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-8',
              name: 'Détecteur De l\'Angle De Braquage',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Détecteur_De_l\'Angle_De_Braquage.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-9',
              name: 'Filtre Hydraulique Direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Filtre_Hydraulique_Direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-10',
              name: 'Huile Pour Direction Assistée',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Huile_Pour_Direction_Assistée.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-11',
              name: 'Indicateur De Pression d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Indicateur_De_Pression_d\'Huile.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-12',
              name: 'Jeu de joints d\'étanchéité pompe hydraulique',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Jeu_de_joints_d\'étanchéité_pompe_hydraulique.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-13',
              name: 'Kit Réparation Rotule De Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Kit_Réparation_Rotule_De_Suspension.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-14',
              name: 'Kit de réparation renvoi de direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Kit_de_réparation_renvoi_de_direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-15',
              name: 'Kit de réparation rotule de barre de connexion',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Kit_de_réparation_rotule_de_barre_de_connexion.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-16',
              name: 'Levier De Direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Levier_De_Direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-17',
              name: 'Outils de direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Outils_de_direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-18',
              name: 'Pièces De Transmission De Direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Pièces_De_Transmission_De_Direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-19',
              name: 'Pompe Hydraulique De Direction Assistée',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Pompe_Hydraulique_De_Direction_Assistée.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-20',
              name: 'Poulie pompe de direction assistée',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Poulie_pompe_de_direction_assistée.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-21',
              name: 'Radiateur d\'huile direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Radiateur_d\'huile_direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-22',
              name: 'Rotule Axiale',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Rotule_Axiale.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-23',
              name: 'Rotule De Direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Rotule_De_Direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-24',
              name: 'Rotule de Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Rotule_de_Suspension.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-25',
              name: 'Soufflet de Direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Soufflet_de_Direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-26',
              name: 'Suspension De La Direction',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Suspension_De_La_Direction.png',
              categoryId: '10',
            ),
            Subcategory(
              id: '10-27',
              name: 'Vase d\'Expansion De l\'Huile Hydraulique',
              imagePath:
                  'assets/images/subcategoryImages/Direction/Vase_d\'Expansion_De_l\'Huile_Hydraulique.png',
              categoryId: '10',
            ),
          ];

        case '11': // Dispositif d'attelage accessoires
          return [
            Subcategory(
              id: '11-1',
              name: 'Attelage',
              imagePath:
                  'assets/images/subcategoryImages/Dispositif_d\'attelage_accessoires/Attelage.png',
              categoryId: '11',
            ),
            Subcategory(
              id: '11-2',
              name: 'Cache Crochet De Remorquage',
              imagePath:
                  'assets/images/subcategoryImages/Dispositif_d\'attelage_accessoires/Cache_Crochet_De_Remorquage.png',
              categoryId: '11',
            ),
            Subcategory(
              id: '11-3',
              name: 'Faisceau Éléctrique D\'Attelage',
              imagePath:
                  'assets/images/subcategoryImages/Dispositif_d\'attelage_accessoires/Faisceau_Éléctrique_D\'Attelage.png',
              categoryId: '11',
            ),
            Subcategory(
              id: '11-4',
              name: 'Support d\'attelage dispositif d\'attelage',
              imagePath:
                  'assets/images/subcategoryImages/Dispositif_d\'attelage_accessoires/Support_d\'attelage_dispositif_d\'attelage.png',
              categoryId: '11',
            ),
          ];

        case '12': // Echappement
          return [
            Subcategory(
              id: '12-1',
              name: 'Capteur de Pression Différentielle',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Capteur_de_Pression_Différentielle.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-2',
              name: 'Capteur de Pression de Suralimentation',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Capteur_de_Pression_de_Suralimentation.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-3',
              name: 'Capteur de Température des Gaz d\'Échappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Capteur_de_Température_des_Gaz_d\'Échappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-4',
              name: 'Catalyseur',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Catalyseur.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-5',
              name: 'Clapet de gaz d\'échappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Clapet_de_gaz_d\'échappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-6',
              name: 'Collecteur d\'Echappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Collecteur_d\'Echappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-7',
              name: 'Collier De Serrage D\'Échappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Collier_De_Serrage_D\'Échappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-8',
              name: 'Embouts d\'Échappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Embouts_d\'Échappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-9',
              name: 'Filtre à Particules',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Filtre_à_Particules.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-10',
              name: 'Fixation Pot d\'Échappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Fixation_Pot_d\'Échappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-11',
              name: 'Fluides échappement diesel AdBlue',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Fluides_échappement_diesel_AdBlue.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-12',
              name: 'Gaine De Suralimentation',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Gaine_De_Suralimentation.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-13',
              name: 'Intercooler',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Intercooler.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-14',
              name: 'Joint De Turbocompresseur',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Joint_De_Turbocompresseur.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-15',
              name: 'Joint De Vanne EGR',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Joint_De_Vanne_EGR.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-16',
              name: 'Joint d\'Echappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Joint_d\'Echappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-17',
              name: 'Joint de Collecteur d\'Echappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Joint_de_Collecteur_d\'Echappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-18',
              name: 'Kit d\'assemblage catalyseur',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Kit_d\'assemblage_catalyseur.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-19',
              name: 'Kit d\'assemblage silencieux',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Kit_d\'assemblage_silencieux.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-20',
              name: 'Kit d\'assemblage système d\'échappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Kit_d\'assemblage_système_d\'échappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-21',
              name: 'Kit de montage collecteur des gaz d\'échappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Kit_de_montage_collecteur_des_gaz_d\'échappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-22',
              name: 'Mise à Niveau Euro1 Euro2',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Mise_à_Niveau_Euro1_Euro2.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-23',
              name: 'Module De Dosage',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Module_De_Dosage.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-24',
              name: 'Nettoyage filtre à particules à suie',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Nettoyage_filtre_à_particules_à_suie.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-25',
              name: 'Peinture moteur et haute température',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Peinture_moteur_et_haute_température.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-26',
              name: 'Pompe d\'injection d\'air secondaire',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Pompe_d\'injection_d\'air_secondaire.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-27',
              name: 'Pot d\'Échappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Pot_d\'Échappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-28',
              name: 'Produits d\'étanchéité échappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Produits_d\'étanchéité_échappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-29',
              name: 'Protection thermique',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Protection_thermique.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-30',
              name: 'Radiateur Réaspiration Des Gaz d\'Echappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Radiateur_Réaspiration_Des_Gaz_d\'Echappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-31',
              name: 'Silencieux Avant',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Silencieux_Avant.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-32',
              name: 'Silencieux Intermédiaire',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Silencieux_Intermédiaire.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-33',
              name: 'Silent-Bloc Caoutchouc D\'Échappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Silent-Bloc_Caoutchouc_D\'Échappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-34',
              name: 'Silent-Bloc De Silencieux Arrière',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Silent-Bloc_De_Silencieux_Arrière.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-35',
              name: 'Sonde Lambda',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Sonde_Lambda.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-36',
              name: 'Soupape d\'Air Secondaire',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Soupape_d\'Air_Secondaire.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-37',
              name: 'Tresse d\'Échappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Tresse_d\'Échappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-38',
              name: 'Turbocompresseur',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Turbocompresseur.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-39',
              name: 'Tuyau d\'Echappement',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Tuyau_d\'Echappement.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-40',
              name: 'Valve D\'Air De Circulation Compresseur',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Valve_D\'Air_De_Circulation_Compresseur.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-41',
              name: 'Vanne Egr',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Vanne_Egr.png',
              categoryId: '12',
            ),
            Subcategory(
              id: '12-42',
              name: 'Électrovanne De Turbo',
              imagePath:
                  'assets/images/subcategoryImages/Echappement/Électrovanne_De_Turbo.png',
              categoryId: '12',
            ),
          ];

        case '13': // Eclairage
          return [
            Subcategory(
              id: '13-1',
              name: 'Ampoule De Feu Clignotant',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Ampoule_De_Feu_Clignotant.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-2',
              name: 'Ampoule Feu Eclaireur De Plaque',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Ampoule_Feu_Eclaireur_De_Plaque.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-3',
              name: 'Ampoule Pour Feux Arrières',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Ampoule_Pour_Feux_Arrières.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-4',
              name: 'Ampoule Pour Projecteur Antibrouillard',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Ampoule_Pour_Projecteur_Antibrouillard.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-5',
              name: 'Ampoule Pour Projecteur Principal',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Ampoule_Pour_Projecteur_Principal.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-6',
              name: 'Ampoule Projecteur Longue Portée',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Ampoule_Projecteur_Longue_Portée.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-7',
              name: 'Ampoule de feu de recul',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Ampoule_de_feu_de_recul.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-8',
              name: 'Ampoules Pour Feux De Stop',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Ampoules_Pour_Feux_De_Stop.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-9',
              name: 'Anti-brouillard',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Anti-brouillard.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-10',
              name: 'Antibrouillard Arriere',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Antibrouillard_Arriere.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-11',
              name: 'Catadioptre Arrière',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Catadioptre_Arrière.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-12',
              name: 'Clignotant',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Clignotant.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-13',
              name: 'Commodo de Phare',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Commodo_de_Phare.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-14',
              name: 'Composants De Feu Arrière',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Composants_De_Feu_Arrière.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-15',
              name: 'Composants Des Projecteurs Principaux',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Composants_Des_Projecteurs_Principaux.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-16',
              name: 'Composants Pour Projecteur Antibrouillard',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Composants_Pour_Projecteur_Antibrouillard.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-17',
              name: 'Compteur Kilométrique',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Compteur_Kilométrique.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-18',
              name: 'Eclairage De Plaque d\'Immatriculation',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Eclairage_De_Plaque_d\'Immatriculation.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-19',
              name: 'Eclairage De l\'Habitacle',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Eclairage_De_l\'Habitacle.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-20',
              name: 'Feu Arrière',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Feu_Arrière.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-21',
              name: 'Feu De Recul',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Feu_De_Recul.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-22',
              name: 'Feu De Stop',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Feu_De_Stop.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-23',
              name: 'Feu Diurne',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Feu_Diurne.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-24',
              name: 'Feu de Position',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Feu_de_Position.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-25',
              name: 'Jeu De Câbles',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Jeu_De_Câbles.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-26',
              name: 'Phare Avant',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Phare_Avant.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-27',
              name: 'Phares Au Xénon',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Phares_Au_Xénon.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-28',
              name: 'Phares additionnels',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Phares_additionnels.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-29',
              name: 'Projecteur longue portée',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Projecteur_longue_portée.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-30',
              name: 'feu stop additionnel',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/feu_stop_additionnel.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-31',
              name: 'Éclairage de porte',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Éclairage_de_porte.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-32',
              name: 'Éclairage du coffre',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Éclairage_du_coffre.png',
              categoryId: '13',
            ),
            Subcategory(
              id: '13-33',
              name: 'Élément d\'Ajustage Correcteur de Portée Lumineuse',
              imagePath:
                  'assets/images/subcategoryImages/Eclairage/Élément_d\'Ajustage_Correcteur_de_Portée_Lumineuse.png',
              categoryId: '13',
            ),
          ];

        case '14': // Embrayage  composants
          return [
            Subcategory(
              id: '14-1',
              name: 'Butée commande d\'embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Butée_commande_d\'embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-2',
              name: 'Butée d\'Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Butée_d\'Embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-3',
              name: 'Conduit D\'Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Conduit_D\'Embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-4',
              name: 'Contacteur d\'Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Contacteur_d\'Embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-5',
              name: 'Câble d\'Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Câble_d\'Embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-6',
              name: 'Disque d\'Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Disque_d\'Embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-7',
              name: 'Douille De Guidage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Douille_De_Guidage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-8',
              name: 'Débrayage Central',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Débrayage_Central.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-9',
              name: 'Emetteur d\'Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Emetteur_d\'Embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-10',
              name: 'Fourchette De Débrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Fourchette_De_Débrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-11',
              name: 'Kit d\'Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Kit_d\'Embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-12',
              name: 'Kit d\'assemblage cylindre récepteur d\'embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Kit_d\'assemblage_cylindre_récepteur_d\'embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-13',
              name: 'Mécanisme d\'Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Mécanisme_d\'Embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-14',
              name: 'Outils embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Outils_embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-15',
              name: 'Palier de Guidage Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Palier_de_Guidage_Embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-16',
              name: 'Produits de nettoyage de freins et embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Produits_de_nettoyage_de_freins_et_embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-17',
              name: 'Pâte d\'assemblage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Pâte_d\'assemblage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-18',
              name: 'Pédale et Couvre Pédale',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Pédale_et_Couvre_Pédale.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-19',
              name: 'Récepteur d\'Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Récepteur_d\'Embrayage.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-20',
              name: 'Vis De Volant Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Vis_De_Volant_Moteur.png',
              categoryId: '14',
            ),
            Subcategory(
              id: '14-21',
              name: 'Volant Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Embrayage__composants/Volant_Moteur.png',
              categoryId: '14',
            ),
          ];

        case '15': // Filtre
          return [
            Subcategory(
              id: '15-1',
              name: 'Bouteille Déshydratante',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Bouteille_Déshydratante.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-2',
              name: 'Boîtier De Filtres à Huile Joint',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Boîtier_De_Filtres_à_Huile_Joint.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-3',
              name: 'Clé à filtre',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Clé_à_filtre.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-4',
              name: 'Durite D\'Admission D\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Durite_D\'Admission_D\'Air.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-5',
              name: 'Filtre Hydraulique Direction',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Filtre_Hydraulique_Direction.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-6',
              name: 'Filtre d\'Habitacle',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Filtre_d\'Habitacle.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-7',
              name: 'Filtre de Boite Automatique',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Filtre_de_Boite_Automatique.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-8',
              name: 'Filtre unité d\'alimentation de carburant',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Filtre_unité_d\'alimentation_de_carburant.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-9',
              name: 'Filtre à Air',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Filtre_à_Air.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-10',
              name: 'Filtre à Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Filtre_à_Carburant.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-11',
              name: 'Filtre à Huile',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Filtre_à_Huile.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-12',
              name: 'Filtre à air sport',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Filtre_à_air_sport.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-13',
              name: 'Jeu de pièces Vidange boîte automatique',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Jeu_de_pièces_Vidange_boîte_automatique.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-14',
              name: 'Joint Etancheité Boîtier De Filtre A Huilde',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Joint_Etancheité_Boîtier_De_Filtre_A_Huilde.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-15',
              name: 'Kit De Filtres',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Kit_De_Filtres.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-16',
              name: 'Soupape filtre à carburant',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Soupape_filtre_à_carburant.png',
              categoryId: '15',
            ),
            Subcategory(
              id: '15-17',
              name: 'Support Bloc Du Filtre A Air',
              imagePath:
                  'assets/images/subcategoryImages/Filtre/Support_Bloc_Du_Filtre_A_Air.png',
              categoryId: '15',
            ),
          ];

        case '16': // Freinage
          return [
            Subcategory(
              id: '16-1',
              name: 'Accumulateur de pression freinage',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Accumulateur_de_pression_freinage.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-2',
              name: 'Adhésifs blocage de filet',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Adhésifs_blocage_de_filet.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-3',
              name: 'Ajusteur Frein À Tambour',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Ajusteur_Frein_À_Tambour.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-4',
              name: 'Appareil de commande dynamique de freinage de roulement',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Appareil_de_commande_dynamique_de_freinage_de_roulement.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-5',
              name: 'Aérosols techniques',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Aérosols_techniques.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-6',
              name: 'Bloc Abs',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Bloc_Abs.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-7',
              name: 'Capteur ABS',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Capteur_ABS.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-8',
              name: 'Capteur accélération longitudinale latérale',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Capteur_accélération_longitudinale_latérale.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-9',
              name: 'Capteur de course de la pédale',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Capteur_de_course_de_la_pédale.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-10',
              name: 'Conduites De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Conduites_De_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-11',
              name: 'Contacteur De Feux Stop',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Contacteur_De_Feux_Stop.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-12',
              name: 'Cylindre De Roue',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Cylindre_De_Roue.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-13',
              name: 'Câble de Frein à Main',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Câble_de_Frein_à_Main.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-14',
              name: 'Deflecteur Disque de Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Deflecteur_Disque_de_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-15',
              name: 'Disque de freins de haute performance',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Disque_de_freins_de_haute_performance.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-16',
              name: 'Disques De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Disques_De_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-17',
              name: 'Douille de Guidage Etrier de Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Douille_de_Guidage_Etrier_de_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-18',
              name: 'Durite Servo Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Durite_Servo_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-19',
              name: 'Flexible De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Flexible_De_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-20',
              name: 'Frein à main',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Frein_à_main.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-21',
              name: 'Freins à tambour',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Freins_à_tambour.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-22',
              name: 'Garnitures de freins de haute performance',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Garnitures_de_freins_de_haute_performance.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-23',
              name: 'Interrupteur témoin de frein à main',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Interrupteur_témoin_de_frein_à_main.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-24',
              name: 'Kit De Freins',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Kit_De_Freins.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-25',
              name: 'Kit Freins À Tambours',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Kit_Freins_À_Tambours.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-26',
              name: 'Kit Réparation Maître-Cylinde De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Kit_Réparation_Maître-Cylinde_De_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-27',
              name: 'Kit Réparation Étanchéité Cylindre de roue',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Kit_Réparation_Étanchéité_Cylindre_de_roue.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-28',
              name: 'Kit d\'Accessoires Mâchoires de Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Kit_d\'Accessoires_Mâchoires_de_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-29',
              name: 'Kit d\'accessoires plaquette de frein à disque',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Kit_d\'accessoires_plaquette_de_frein_à_disque.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-30',
              name: 'Kit de Réparation Étrier de Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Kit_de_Réparation_Étrier_de_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-31',
              name: 'Kit de réparation axe de frein de stationnement',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Kit_de_réparation_axe_de_frein_de_stationnement.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-32',
              name: 'Liquide De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Liquide_De_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-33',
              name: 'Lubrifiants',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Lubrifiants.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-34',
              name: 'Mastervac',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Mastervac.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-35',
              name: 'Maître-Cylindre',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Maître-Cylindre.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-36',
              name: 'Mâchoires De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Mâchoires_De_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-37',
              name: 'Mâchoires de Frein à Main',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Mâchoires_de_Frein_à_Main.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-38',
              name: 'Outils pour freins',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Outils_pour_freins.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-39',
              name: 'Peinture étrier de frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Peinture_étrier_de_frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-40',
              name: 'Piston d\'Étrier De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Piston_d\'Étrier_De_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-41',
              name: 'Plaquettes de Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Plaquettes_de_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-42',
              name: 'Pompe à Vide de Freinage',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Pompe_à_Vide_de_Freinage.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-43',
              name: 'Produits de nettoyage de freins et embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Produits_de_nettoyage_de_freins_et_embrayage.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-44',
              name: 'Pâte d\'assemblage',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Pâte_d\'assemblage.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-45',
              name: 'Relais abs',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Relais_abs.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-46',
              name: 'Répartiteur De Freinage',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Répartiteur_De_Freinage.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-47',
              name: 'Support d\'Étrier De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Support_d\'Étrier_De_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-48',
              name: 'Tambours De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Tambours_De_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-49',
              name: 'Témoin d\'Usure Plaquettes De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Témoin_d\'Usure_Plaquettes_De_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-50',
              name: 'Vase d\'Expansion Liquide de Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Vase_d\'Expansion_Liquide_de_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-51',
              name: 'Vis Disque De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Vis_Disque_De_Frein.png',
              categoryId: '16',
            ),
            Subcategory(
              id: '16-52',
              name: 'Étrier De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Freinage/Étrier_De_Frein.png',
              categoryId: '16',
            ),
          ];

        case '17': // Intérieur et Confort
          return [
            Subcategory(
              id: '17-1',
              name: 'Ajustage Du Miroir',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Ajustage_Du_Miroir.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-2',
              name: 'Antennes',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Antennes.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-3',
              name: 'Appareil de commande chauffage ventilation',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Appareil_de_commande_chauffage_ventilation.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-4',
              name: 'Bouton de verrouillage',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Bouton_de_verrouillage.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-5',
              name: 'Capteurs de Recul',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Capteurs_de_Recul.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-6',
              name: 'Coffre à Bagages',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Coffre_à_Bagages.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-7',
              name: 'Commodo de Phare',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Commodo_de_Phare.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-8',
              name: 'Commutateur Sous Volant',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Commutateur_Sous_Volant.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-9',
              name: 'Composants Pommeau Boite De Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Composants_Pommeau_Boite_De_Vitesse.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-10',
              name: 'Contacteur De Feux Stop',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Contacteur_De_Feux_Stop.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-11',
              name: 'Contacteur Leve-Vitre',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Contacteur_Leve-Vitre.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-12',
              name: 'Cylindre de Serrure',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Cylindre_de_Serrure.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-13',
              name: 'Câble Flexible De Commande De Compteur',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Câble_Flexible_De_Commande_De_Compteur.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-14',
              name: 'Détecteur De l\'Angle De Braquage',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Détecteur_De_l\'Angle_De_Braquage.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-15',
              name: 'Fermeture Centralisée',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Fermeture_Centralisée.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-16',
              name: 'Interrupteur D\'Allumage De Démarreur',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Interrupteur_D\'Allumage_De_Démarreur.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-17',
              name: 'Interrupteur contacteur de porte',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Interrupteur_contacteur_de_porte.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-18',
              name: 'Interrupteur feu antibrouillard',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Interrupteur_feu_antibrouillard.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-19',
              name: 'Interrupteur témoin de frein à main',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Interrupteur_témoin_de_frein_à_main.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-20',
              name: 'Lève-Vitre',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Lève-Vitre.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-21',
              name: 'Manivelle De Leve-Vitre',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Manivelle_De_Leve-Vitre.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-22',
              name: 'Moteur Lève Vitre',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Moteur_Lève_Vitre.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-23',
              name: 'Poignée De Porte',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Poignée_De_Porte.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-24',
              name: 'Pompe De Circulation d\'Eau Chauffage Auxiliaire',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Pompe_De_Circulation_d\'Eau_Chauffage_Auxiliaire.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-25',
              name: 'Porte boissons',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Porte_boissons.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-26',
              name:
                  'Produits de nettoyage d\'intérieur et entretien de voiture',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Produits_de_nettoyage_d\'intérieur_et_entretien_de_voiture.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-27',
              name: 'Pédale d\'accélérateur',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Pédale_d\'accélérateur.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-28',
              name: 'Pédale et Couvre Pédale',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Pédale_et_Couvre_Pédale.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-29',
              name: 'Recouvrement',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Recouvrement.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-30',
              name: 'Resistance',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Resistance.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-31',
              name: 'Ressort pneumatique table pliante',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Ressort_pneumatique_table_pliante.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-32',
              name: 'Réglage de Siège',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Réglage_de_Siège.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-33',
              name: 'Rétroviseur Intérieur',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Rétroviseur_Intérieur.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-34',
              name: 'Serrure De Porte',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Serrure_De_Porte.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-35',
              name: 'Serrure intérieure',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Serrure_intérieure.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-36',
              name: 'Système électrique central',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Système_électrique_central.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-37',
              name: 'Tapis de plancher',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Tapis_de_plancher.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-38',
              name: 'Verin De Hayon',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Verin_De_Hayon.png',
              categoryId: '17',
            ),
            Subcategory(
              id: '17-39',
              name: 'Éponges lingettes et brosses',
              imagePath:
                  'assets/images/subcategoryImages/Intérieur_et_Confort/Éponges_lingettes_et_brosses.png',
              categoryId: '17',
            ),
          ];

        case '18': // Joints et Rondelles d'Étanchéité
          return [
            Subcategory(
              id: '18-1',
              name: 'Bague D\'Étanchéité De Différentiel',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Bague_D\'Étanchéité_De_Différentiel.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-2',
              name: 'Bague d\'étanchéité arbre de transmission',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Bague_d\'étanchéité_arbre_de_transmission.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-3',
              name: 'Bague Étanchéité Roulement Avant',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Bague_Étanchéité_Roulement_Avant.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-4',
              name: 'Joint Boite de Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_Boite_de_Vitesse.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-5',
              name: 'Joint Carte D\'Huile Boite À Vitesses Automatique',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_Carte_D\'Huile_Boite_À_Vitesses_Automatique.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-6',
              name: 'Joint Collecteur d\'Admission',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_Collecteur_d\'Admission.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-7',
              name: 'Joint Collerette De Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_Collerette_De_Climatisation.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-8',
              name: 'Joint D\'Étanchéité Boîtier De Filtre À Huilde',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_D\'Étanchéité_Boîtier_De_Filtre_À_Huilde.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-9',
              name: 'Joint D\'Étanchéité Conduit De Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_D\'Étanchéité_Conduit_De_Climatisation.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-10',
              name: 'Joint D\'Étanchéité Pompe À Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_D\'Étanchéité_Pompe_À_Carburant.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-11',
              name: 'Joint De Cache-Culbuteurs',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_De_Cache-Culbuteurs.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-12',
              name: 'Joint De Carter De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_De_Carter_De_Distribution.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-13',
              name: 'Joint De Culasse',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_De_Culasse.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-14',
              name: 'Joint De Pare Brise',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_De_Pare_Brise.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-15',
              name: 'Joint De Pompe à Huile',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_De_Pompe_à_Huile.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-16',
              name: 'Joint De Queue De Soupape',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_De_Queue_De_Soupape.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-17',
              name: 'Joint De Turbocompresseur',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_De_Turbocompresseur.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-18',
              name: 'Joint De Vanne EGR',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_De_Vanne_EGR.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-19',
              name: 'Joint Injecteur',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_Injecteur.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-20',
              name: 'Joint Pompe à Eau',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_Pompe_à_Eau.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-21',
              name: 'Joint Spi de Vilebrequin',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_Spi_de_Vilebrequin.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-22',
              name: 'Joint d\'Eau De Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_d\'Eau_De_Refroidissement.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-23',
              name: 'Joint d\'Echappement',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_d\'Echappement.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-24',
              name:
                  'Joint d\'étanchéité bouchon de goulotte remplissage d\'huile',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_d\'étanchéité_bouchon_de_goulotte_remplissage_d\'huile.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-25',
              name: 'Joint d\'étanchéité de porte',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_d\'étanchéité_de_porte.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-26',
              name: 'Joint d\'étanchéité filtre de carburant',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_d\'étanchéité_filtre_de_carburant.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-27',
              name: 'Joint de Bouchon Vidange',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_de_Bouchon_Vidange.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-28',
              name: 'Joint de Calorstat',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_de_Calorstat.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-29',
              name: 'Joint de Carter d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_de_Carter_d\'Huile.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-30',
              name: 'Joint de Collecteur d\'Echappement',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_de_Collecteur_d\'Echappement.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-31',
              name: 'Joint de Radiateur d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_de_Radiateur_d\'Huile.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-32',
              name: 'Joint jauge de niveau d\'huile',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_jauge_de_niveau_d\'huile.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-33',
              name: 'Joint spi de vilebrequin2',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Joint_spi_de_vilebrequin2.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-34',
              name: 'Kit de Montage Compresseur',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Kit_de_Montage_Compresseur.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-35',
              name: 'Pochette de Joint Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Pochette_de_Joint_Moteur.png',
              categoryId: '18',
            ),
            Subcategory(
              id: '18-36',
              name: 'Rondelle d\'étanchéité bouchon vissable de radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Joints_et_Rondelles_d\'Étanchéité/Rondelle_d\'étanchéité_bouchon_vissable_de_radiateur.png',
              categoryId: '18',
            ),
          ];

        case '19': // Kits De Réparation
          return [
            Subcategory(
              id: '19-1',
              name: 'Composant Alternateur',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Composant_Alternateur.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-2',
              name: 'Composants Du Démarreur',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Composants_Du_Démarreur.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-3',
              name: 'Douille de Guidage Etrier de Frein',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Douille_de_Guidage_Etrier_de_Frein.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-4',
              name: 'Kit D\'Assemblage Bras De Liaison',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_D\'Assemblage_Bras_De_Liaison.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-5',
              name: 'Kit De Réparation Injecteur',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_De_Réparation_Injecteur.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-6',
              name: 'Kit Réparation Biellette De Barre Stabilisatrice',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_Réparation_Biellette_De_Barre_Stabilisatrice.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-7',
              name: 'Kit Réparation Levier Changement De Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_Réparation_Levier_Changement_De_Vitesse.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-8',
              name: 'Kit Réparation Rotule De Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_Réparation_Rotule_De_Suspension.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-9',
              name: 'Kit Réparation Suspension De Roue',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_Réparation_Suspension_De_Roue.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-10',
              name: 'Kit d\'Accessoires Mâchoires de Frein',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_d\'Accessoires_Mâchoires_de_Frein.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-11',
              name: 'Kit d\'assemblage cylindre récepteur d\'embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_d\'assemblage_cylindre_récepteur_d\'embrayage.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-12',
              name: 'Kit d\'assemblage cylindre émetteur d\'embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_d\'assemblage_cylindre_émetteur_d\'embrayage.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-13',
              name: 'Kit de Réparation Bras de Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_de_Réparation_Bras_de_Suspension.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-14',
              name: 'Kit de Réparation Levier de Changement de Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_de_Réparation_Levier_de_Changement_de_Vitesse.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-15',
              name: 'Kit de Réparation Étrier de Frein',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_de_Réparation_Étrier_de_Frein.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-16',
              name: 'Kit de réparation ajustage automatique',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_de_réparation_ajustage_automatique.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-17',
              name: 'Kit de réparation renvoi de direction',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_de_réparation_renvoi_de_direction.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-18',
              name: 'Kit de réparation ventilation du carter-moteur',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Kit_de_réparation_ventilation_du_carter-moteur.png',
              categoryId: '19',
            ),
            Subcategory(
              id: '19-19',
              name: 'Soupape dégazage du carter',
              imagePath:
                  'assets/images/subcategoryImages/Kits_De_Réparation/Soupape_dégazage_du_carter.png',
              categoryId: '19',
            ),
          ];

        case '20': // Moteur
          return [
            Subcategory(
              id: '20-1',
              name: 'Additifs huile de moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Additifs_huile_de_moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-2',
              name: 'Additifs pour turbocompresseur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Additifs_pour_turbocompresseur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-3',
              name: 'Adhésifs blocage de filet',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Adhésifs_blocage_de_filet.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-4',
              name: 'Antigel',
              imagePath: 'assets/images/subcategoryImages/Moteur/Antigel.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-5',
              name: 'Arbre intermédiaire et arbre à contrepoids d\'équilibrage',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Arbre_intermédiaire_et_arbre_à_contrepoids_d\'équilibrage.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-6',
              name: 'Arbre à Cames',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Arbre_à_Cames.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-7',
              name: 'Aérosols techniques',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Aérosols_techniques.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-8',
              name: 'Bague d\'étanchéité arbre intermédiaire',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Bague_d\'étanchéité_arbre_intermédiaire.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-9',
              name: 'Bague d\'étanchéité pompe à huile',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Bague_d\'étanchéité_pompe_à_huile.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-10',
              name: 'Bielle',
              imagePath: 'assets/images/subcategoryImages/Moteur/Bielle.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-11',
              name: 'Bobines d\'Allumage',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Bobines_d\'Allumage.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-12',
              name: 'Boitier Papillon',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Boitier_Papillon.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-13',
              name: 'Bouchon Liquide de Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Bouchon_Liquide_de_Refroidissement.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-14',
              name: 'Bouchon de Carter d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Bouchon_de_Carter_d\'Huile.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-15',
              name: 'Bouchon goulotte de remplissage d\'huile',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Bouchon_goulotte_de_remplissage_d\'huile.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-16',
              name: 'Bougie De Préchauffage',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Bougie_De_Préchauffage.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-17',
              name: 'Bougies d\'Allumage',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Bougies_d\'Allumage.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-18',
              name: 'Boulon de poulie',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Boulon_de_poulie.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-19',
              name: 'Bride De Liquide De Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Bride_De_Liquide_De_Refroidissement.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-20',
              name: 'Cache Culbuteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Cache_Culbuteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-21',
              name: 'Cale de blocage de soupape',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Cale_de_blocage_de_soupape.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-22',
              name: 'Capteur Aac',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Capteur_Aac.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-23',
              name: 'Capteur Niveau d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Capteur_Niveau_d\'Huile.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-24',
              name: 'Capteur PMH',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Capteur_PMH.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-25',
              name: 'Capteur Pression D\'Admission',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Capteur_Pression_D\'Admission.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-26',
              name: 'Capteur de Pression de Suralimentation',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Capteur_de_Pression_de_Suralimentation.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-27',
              name: 'Carter d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Carter_d\'Huile.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-28',
              name: 'Carter de vilebrequin',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Carter_de_vilebrequin.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-29',
              name: 'Chaîne De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Chaîne_De_Distribution.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-30',
              name: 'Chemises de cylindre',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Chemises_de_cylindre.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-31',
              name: 'Circuit Électrique Du Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Circuit_Électrique_Du_Moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-32',
              name: 'Collecteur d\'Admission',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Collecteur_d\'Admission.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-33',
              name: 'Composé de meulage de soupape',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Composé_de_meulage_de_soupape.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-34',
              name: 'Courroie De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Courroie_De_Distribution.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-35',
              name: 'Courroie Trapézoïdale',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Courroie_Trapézoïdale.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-36',
              name: 'Courroie Trapézoïdale à Nervures',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Courroie_Trapézoïdale_à_Nervures.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-37',
              name: 'Coussinet De Bielle',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Coussinet_De_Bielle.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-38',
              name: 'Coussinet de palier',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Coussinet_de_palier.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-39',
              name: 'Coussinet de vilebrequin',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Coussinet_de_vilebrequin.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-40',
              name: 'Culasse',
              imagePath: 'assets/images/subcategoryImages/Moteur/Culasse.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-41',
              name: 'Culbuteur',
              imagePath: 'assets/images/subcategoryImages/Moteur/Culbuteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-42',
              name: 'Câble d\'Accélérateur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Câble_d\'Accélérateur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-43',
              name: 'Dispositif de réglage électrique d\'arbre à cames',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Dispositif_de_réglage_électrique_d\'arbre_à_cames.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-44',
              name: 'Doigt d\'Allumeur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Doigt_d\'Allumeur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-45',
              name: 'Durite de Radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Durite_de_Radiateur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-46',
              name: 'Débitmètre d\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Débitmètre_d\'Air.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-47',
              name: 'Electrovanne De Commande Arbre a cames',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Electrovanne_De_Commande_Arbre_a_cames.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-48',
              name: 'Embrayage Ventilateur De Radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Embrayage_Ventilateur_De_Radiateur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-49',
              name: 'Faisceau d\'Allumage',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Faisceau_d\'Allumage.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-50',
              name: 'Filtre à Air',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Filtre_à_Air.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-51',
              name: 'Filtre à Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Filtre_à_Carburant.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-52',
              name: 'Filtre à Huile',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Filtre_à_Huile.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-53',
              name: 'Gaine De Suralimentation',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Gaine_De_Suralimentation.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-54',
              name: 'Galet Tendeur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Galet_Tendeur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-55',
              name: 'Galet Tendeur Courroie Crantée',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Galet_Tendeur_Courroie_Crantée.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-56',
              name: 'Galet enrouleur de courroie d\'accessoire',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Galet_enrouleur_de_courroie_d\'accessoire.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-57',
              name: 'Guide De Soupape Joint Réglage',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Guide_De_Soupape__Joint__Réglage.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-58',
              name: 'Guide Fixe',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Guide_Fixe.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-59',
              name: 'Huile Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Huile_Moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-60',
              name: 'Injecteurs',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Injecteurs.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-61',
              name: 'Intercooler',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Intercooler.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-62',
              name: 'Interrupteur de Température ventilateur de radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Interrupteur_de_Température_ventilateur_de_radiateur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-63',
              name: 'Jauge d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Jauge_d\'Huile.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-64',
              name: 'Jeu De Courroies Trapézoïdales à Nervures',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Jeu_De_Courroies_Trapézoïdales_à_Nervures.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-65',
              name: 'Jeu De Joints d\'Etanchéité Carter De vilebrequin',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Jeu_De_Joints_d\'Etanchéité_Carter_De_vilebrequin.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-66',
              name: 'Jeu de joints d\'etancheité culasse de cylindre',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Jeu_de_joints_d\'etancheité_culasse_de_cylindre.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-67',
              name: 'Jeu de joints d\'étancheité chemise de cylindre',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Jeu_de_joints_d\'étancheité_chemise_de_cylindre.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-68',
              name: 'Joint Collecteur d\'Admission',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_Collecteur_d\'Admission.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-69',
              name: 'Joint De Cache Culbuteurs',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_De_Cache_Culbuteurs.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-70',
              name: 'Joint De Culasse',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_De_Culasse.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-71',
              name: 'Joint De Queue De Soupape',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_De_Queue_De_Soupape.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-72',
              name: 'Joint De Turbocompresseur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_De_Turbocompresseur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-73',
              name: 'Joint Injecteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_Injecteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-74',
              name: 'Joint Spi d\'Arbre à Came',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_Spi_d\'Arbre_à_Came.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-75',
              name: 'Joint Spi de Vilebrequin',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_Spi_de_Vilebrequin.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-76',
              name: 'Joint d\'Eau De Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_d\'Eau_De_Refroidissement.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-77',
              name: 'Joint de Bouchon Vidange',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_de_Bouchon_Vidange.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-78',
              name: 'Joint de Carter d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_de_Carter_d\'Huile.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-79',
              name: 'Joint de Collecteur d\'Echappement',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Joint_de_Collecteur_d\'Echappement.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-80',
              name: 'Kit Chaîne De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Kit_Chaîne_De_Distribution.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-81',
              name: 'Kit De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Kit_De_Distribution.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-82',
              name: 'Kit de Montage Compresseur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Kit_de_Montage_Compresseur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-83',
              name: 'Lubrifiants',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Lubrifiants.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-84',
              name: 'Outils pour moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Outils_pour_moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-85',
              name: 'Peinture moteur & haute température',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Peinture_moteur_&_haute_température.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-86',
              name: 'Pignon de Vilebrequin',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Pignon_de_Vilebrequin.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-87',
              name: 'Piston',
              imagePath: 'assets/images/subcategoryImages/Moteur/Piston.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-88',
              name: 'Pochette de Joint Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Pochette_de_Joint_Moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-89',
              name: 'Pompe Haute Pression',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Pompe_Haute_Pression.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-90',
              name: 'Pompe à Eau',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Pompe_à_Eau.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-91',
              name: 'Pompe à Eau Kit De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Pompe_à_Eau_Kit_De_Distribution.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-92',
              name: 'Pompe à Huile Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Pompe_à_Huile_Moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-93',
              name: 'Pompe à Vide de Freinage',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Pompe_à_Vide_de_Freinage.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-94',
              name: 'Poulie D\'Arbre À Came',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Poulie_D\'Arbre_À_Came.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-95',
              name: 'Poulie Damper',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Poulie_Damper.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-96',
              name: 'Poulie renvoi transmission courroie de distribution',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Poulie_renvoi__transmission_courroie_de_distribution.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-97',
              name: 'Poulie tendeur courroie crantée',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Poulie_tendeur_courroie_crantée.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-98',
              name: 'Poulies De Vilebrequin',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Poulies_De_Vilebrequin.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-99',
              name: 'Poussoir Hydraulique',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Poussoir_Hydraulique.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-100',
              name: 'Pressostat d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Pressostat_d\'Huile.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-101',
              name: 'Produits d\'étanchéité bloc moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Produits_d\'étanchéité_bloc_moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-102',
              name: 'Produits d\'étanchéité tout usage',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Produits_d\'étanchéité_tout_usage.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-103',
              name: 'Produits de nettoyage du moteur & système de carburation',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Produits_de_nettoyage_du_moteur_&_système_de_carburation.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-104',
              name: 'Radiateur Réaspiration Des Gaz d\'Echappement',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Radiateur_Réaspiration_Des_Gaz_d\'Echappement.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-105',
              name: 'Radiateur d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Radiateur_d\'Huile.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-106',
              name: 'Radiateur de Refroidissement Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Radiateur_de_Refroidissement_Moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-107',
              name: 'Reniflard Carter Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Reniflard_Carter_Moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-108',
              name: 'Régulateur De Pression Du Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Régulateur_De_Pression_Du_Carburant.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-109',
              name: 'Régulateur de Ralenti',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Régulateur_de_Ralenti.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-110',
              name: 'Segments De Pistons',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Segments_De_Pistons.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-111',
              name: 'Sonde Lambda',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Sonde_Lambda.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-112',
              name: 'Sonde de Température Liquide de Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Sonde_de_Température_Liquide_de_Refroidissement.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-113',
              name: 'Soupape d\'Admission',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Soupape_d\'Admission.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-114',
              name: 'Soupape d\'Échappement',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Soupape_d\'Échappement.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-115',
              name: 'Support Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Support_Moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-116',
              name: 'Support d\'arbre à came',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Support_d\'arbre_à_came.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-117',
              name: 'Teinture de détection de fuite',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Teinture_de_détection_de_fuite.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-118',
              name: 'Tendeur De Chaine De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Tendeur_De_Chaine_De_Distribution.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-119',
              name: 'Tendeur de Courroie',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Tendeur_de_Courroie.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-120',
              name: 'Thermostat',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Thermostat.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-121',
              name: 'Turbocompresseur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Turbocompresseur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-122',
              name: 'Tuyau d\'Admission Pompe à Huile',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Tuyau_d\'Admission_Pompe_à_Huile.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-123',
              name: 'Tête De Delco',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Tête_De_Delco.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-124',
              name: 'Tête de bielle et écrou',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Tête_de_bielle_et_écrou.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-125',
              name: 'Valve D\'Air De Circulation Compresseur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Valve_D\'Air_De_Circulation_Compresseur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-126',
              name: 'Valvle Contrôle D\'Air -',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Valvle_Contrôle_D\'Air_-.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-127',
              name: 'Vanne Egr',
              imagePath: 'assets/images/subcategoryImages/Moteur/Vanne_Egr.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-128',
              name: 'Vase d\'Expansion',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Vase_d\'Expansion.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-129',
              name: 'Ventilateur Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Ventilateur_Moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-130',
              name: 'Vilebrequin',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Vilebrequin.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-131',
              name: 'Vis De Culasse',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Vis_De_Culasse.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-132',
              name: 'Vis de palier de vilebrequin',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Vis_de_palier_de_vilebrequin.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-133',
              name: 'Volant Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Volant_Moteur.png',
              categoryId: '20',
            ),
            Subcategory(
              id: '20-134',
              name: 'Électrovanne De Turbo',
              imagePath:
                  'assets/images/subcategoryImages/Moteur/Électrovanne_De_Turbo.png',
              categoryId: '20',
            ),
          ];

        case '21': // Nettoyage des vitres
          return [
            Subcategory(
              id: '21-1',
              name: 'Balai d\'essuie-glace nettoyage des phares',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Balai_d\'essuie-glace_nettoyage_des_phares.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-2',
              name: 'Bocal Lave-Glace',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Bocal_Lave-Glace.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-3',
              name: 'Bras d\'Essuie-Glace',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Bras_d\'Essuie-Glace.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-4',
              name: 'Capteur de pluie',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Capteur_de_pluie.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-5',
              name: 'Capteur niveau de l\'eau de lavage',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Capteur_niveau_de_l\'eau_de_lavage.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-6',
              name: 'Essuie-Glaces',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Essuie-Glaces.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-7',
              name: 'Gicleur Lave-Glace',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Gicleur_Lave-Glace.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-8',
              name: 'Gicleur d\'eau de nettoyage nettoyage des phares',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Gicleur_d\'eau_de_nettoyage_nettoyage_des_phares.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-9',
              name: 'Lame d\'Essuie-Glace',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Lame_d\'Essuie-Glace.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-10',
              name: 'Moteur d\'Essuie-Glace',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Moteur_d\'Essuie-Glace.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-11',
              name: 'Nettoyant pour vitres',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Nettoyant_pour_vitres.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-12',
              name: 'Pièce de jonction tuyauterie d\'eau de nettoyage',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Pièce_de_jonction_tuyauterie_d\'eau_de_nettoyage.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-13',
              name: 'Pompe De Lave-Glace',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Pompe_De_Lave-Glace.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-14',
              name: 'Pompe Lave Projecteur Avant',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Pompe_Lave_Projecteur_Avant.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-15',
              name: 'Relais d\'Essuie-Glace',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Relais_d\'Essuie-Glace.png',
              categoryId: '21',
            ),
            Subcategory(
              id: '21-16',
              name: 'Tringlerie d\'Essuie-Glace',
              imagePath:
                  'assets/images/subcategoryImages/Nettoyage_des_vitres/Tringlerie_d\'Essuie-Glace.png',
              categoryId: '21',
            ),
          ];

        case '22': // Pneus et produits associés
          return [
            Subcategory(
              id: '22-1',
              name: 'Adhésifs à base de caoutchouc',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Adhésifs_à_base_de_caoutchouc.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-2',
              name: 'Boulon de Roue',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Boulon_de_Roue.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-3',
              name: 'Cale de roue',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Cale_de_roue.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-4',
              name: 'Chaine neige',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Chaine_neige.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-5',
              name: 'Contrôle De Pression Des Pneumatiques',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Contrôle_De_Pression_Des_Pneumatiques.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-6',
              name: 'Cric',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Cric.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-7',
              name: 'Démonte roues',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Démonte_roues.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-8',
              name: 'Ecartement Des Roues Élargi',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Ecartement_Des_Roues_Élargi.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-9',
              name: 'Enjoliveurs',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Enjoliveurs.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-10',
              name: 'Gonfleur Pneu',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Gonfleur_Pneu.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-11',
              name: 'Housse De Pneu',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Housse_De_Pneu.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-12',
              name: 'Kit de réparation de pneu',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Kit_de_réparation_de_pneu.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-13',
              name: 'Pneus',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Pneus.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-14',
              name:
                  'Produits de nettoyage d\'intérieur et entretien de voiture',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Produits_de_nettoyage_d\'intérieur_et_entretien_de_voiture.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-15',
              name: 'Pâte d\'assemblage',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Pâte_d\'assemblage.png',
              categoryId: '22',
            ),
            Subcategory(
              id: '22-16',
              name: 'Écrou de roue',
              imagePath:
                  'assets/images/subcategoryImages/Pneus_et_produits_associés/Écrou_de_roue.png',
              categoryId: '22',
            ),
          ];

        case '23': // Recirculation des gaz d'échappement
          return [
            Subcategory(
              id: '23-1',
              name: 'Attelage',
              imagePath:
                  'assets/images/subcategoryImages/Recirculation_des_gaz_d\'échappement/Attelage.png',
              categoryId: '23',
            ),
            Subcategory(
              id: '23-2',
              name: 'Cache Crochet De Remorquage',
              imagePath:
                  'assets/images/subcategoryImages/Recirculation_des_gaz_d\'échappement/Cache_Crochet_De_Remorquage.png',
              categoryId: '23',
            ),
            Subcategory(
              id: '23-3',
              name: 'Faisceau Éléctrique D\'Attelage',
              imagePath:
                  'assets/images/subcategoryImages/Recirculation_des_gaz_d\'échappement/Faisceau_Éléctrique_D\'Attelage.png',
              categoryId: '23',
            ),
            Subcategory(
              id: '23-4',
              name: 'Support d\'attelage dispositif d\'attelage',
              imagePath:
                  'assets/images/subcategoryImages/Recirculation_des_gaz_d\'échappement/Support_d\'attelage_dispositif_d\'attelage.png',
              categoryId: '23',
            ),
          ];

        case '24': // Refroidissement Moteur
          return [
            Subcategory(
              id: '24-1',
              name: 'Antigel',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Antigel.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-2',
              name: 'Bague d\'étanchéité interrupteur de thermostat',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Bague_d\'étanchéité_interrupteur_de_thermostat.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-3',
              name: 'Bouchon De Radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Bouchon_De_Radiateur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-4',
              name: 'Bouchon Liquide de Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Bouchon_Liquide_de_Refroidissement.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-5',
              name: 'Bouchon de dilatation',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Bouchon_de_dilatation.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-6',
              name: 'Bride De Liquide De Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Bride_De_Liquide_De_Refroidissement.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-7',
              name: 'Capteur Niveau Liquide De Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Capteur_Niveau_Liquide_De_Refroidissement.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-8',
              name: 'Commande ventilateur électrique refroidissement du moteur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Commande_ventilateur_électrique_refroidissement_du_moteur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-9',
              name: 'Durite de Radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Durite_de_Radiateur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-10',
              name: 'Déflecteur d\'air de ventilateur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Déflecteur_d\'air_de_ventilateur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-11',
              name: 'Eau distillée',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Eau_distillée.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-12',
              name: 'Embrayage Ventilateur De Radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Embrayage_Ventilateur_De_Radiateur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-13',
              name: 'Gaine radiateur d\'huile de boîte de vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Gaine_radiateur_d\'huile_de_boîte_de_vitesse.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-14',
              name: 'Helice Moto Ventilateur Du Radiateur Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Helice_Moto_Ventilateur_Du_Radiateur_Moteur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-15',
              name: 'Intercooler',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Intercooler.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-16',
              name: 'Interrupteur de Température ventilateur de radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Interrupteur_de_Température_ventilateur_de_radiateur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-17',
              name: 'Jeu De Courroies Trapézoïdales à Nervures',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Jeu_De_Courroies_Trapézoïdales_à_Nervures.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-18',
              name: 'Joint Collerette De Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Joint_Collerette_De_Climatisation.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-19',
              name: 'Joint d\'Eau De Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Joint_d\'Eau_De_Refroidissement.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-20',
              name: 'Joint d\'etanchéité tuyau de liquide de refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Joint_d\'etanchéité_tuyau_de_liquide_de_refroidissement.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-21',
              name: 'Joint d\'étanchéification conduite de réfrigérant',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Joint_d\'étanchéification_conduite_de_réfrigérant.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-22',
              name: 'Joint de Calorstat',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Joint_de_Calorstat.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-23',
              name: 'Joint de Radiateur d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Joint_de_Radiateur_d\'Huile.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-24',
              name: 'Moteur électrique ventilateur pour radiateurs',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Moteur_électrique_ventilateur_pour_radiateurs.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-25',
              name: 'Outils pour système de refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Outils_pour_système_de_refroidissement.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-26',
              name: 'Pièces De Fixation Du Radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Pièces_De_Fixation_Du_Radiateur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-27',
              name: 'Pompe à Eau',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Pompe_à_Eau.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-28',
              name: 'Pompe à Eau Kit De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Pompe_à_Eau__Kit_De_Distribution.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-29',
              name: 'Poulie pompe à eau',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Poulie_pompe_à_eau.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-30',
              name: 'Pressostat hydraulique des freins',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Pressostat_hydraulique_des_freins.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-31',
              name: 'Produits d\'étancheité radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Produits_d\'étancheité_radiateur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-32',
              name: 'Produits d\'étanchéité brides',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Produits_d\'étanchéité_brides.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-33',
              name: 'Produits d\'étanchéité tout usage',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Produits_d\'étanchéité_tout_usage.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-34',
              name: 'Produits de nettoyage et purge de radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Produits_de_nettoyage_et_purge_de_radiateur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-35',
              name: 'Radiateur d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Radiateur_d\'Huile.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-36',
              name: 'Radiateur de Refroidissement Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Radiateur_de_Refroidissement_Moteur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-37',
              name: 'Relais Chasse Du Ventilateur De Radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Relais_Chasse_Du_Ventilateur_De_Radiateur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-38',
              name: 'Sonde de Température Liquide de Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Sonde_de_Température_Liquide_de_Refroidissement.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-39',
              name: 'Support ventilateur de radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Support_ventilateur_de_radiateur.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-40',
              name: 'Thermostat',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Thermostat.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-41',
              name: 'Thermostat d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Thermostat_d\'Huile.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-42',
              name: 'Tuyau d\'huile',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Tuyau_d\'huile.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-43',
              name: 'Vase d\'Expansion',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Vase_d\'Expansion.png',
              categoryId: '24',
            ),
            Subcategory(
              id: '24-44',
              name: 'Ventilateur Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Refroidissement_Moteur/Ventilateur_Moteur.png',
              categoryId: '24',
            ),
          ];

        case '25': // Roulements
          return [
            Subcategory(
              id: '25-1',
              name: 'Bague Étanchéité Roulement Avant',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Bague_Étanchéité_Roulement_Avant.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-2',
              name: 'Butée d\'Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Butée_d\'Embrayage.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-3',
              name: 'Coussinet De Bielle',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Coussinet_De_Bielle.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-4',
              name: 'Coussinet de vilebrequin',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Coussinet_de_vilebrequin.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-5',
              name: 'Coussinet fusée d\'essieu',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Coussinet_fusée_d\'essieu.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-6',
              name: 'Douille De Guidage',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Douille_De_Guidage.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-7',
              name: 'Débrayage Central',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Débrayage_Central.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-8',
              name: 'Palier Relais Arbre Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Palier_Relais_Arbre_Moteur.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-9',
              name: 'Palier de transmission alternateur',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Palier_de_transmission_alternateur.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-10',
              name: 'Roulement De Roues',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Roulement_De_Roues.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-11',
              name: 'Support d\'arbre à came',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Support_d\'arbre_à_came.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-12',
              name: 'Suspension Arbre De Cardan',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Suspension_Arbre_De_Cardan.png',
              categoryId: '25',
            ),
            Subcategory(
              id: '25-13',
              name: 'Suspension Boîte Manuelle',
              imagePath:
                  'assets/images/subcategoryImages/Roulements/Suspension_Boîte_Manuelle.png',
              categoryId: '25',
            ),
          ];

        case '26': // Suspension et Bras
          return [
            Subcategory(
              id: '26-1',
              name: 'Adhésifs blocage de filet',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Adhésifs_blocage_de_filet.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-2',
              name: 'Aérosols techniques',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Aérosols_techniques.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-3',
              name: 'Bague Abs',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Bague_Abs.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-4',
              name: 'Bague Étanchéité Roulement Avant',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Bague_Étanchéité_Roulement_Avant.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-5',
              name: 'Barre Stabilisatrice',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Barre_Stabilisatrice.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-6',
              name: 'Biellette De Barre Stabilisatrice',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Biellette_De_Barre_Stabilisatrice.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-7',
              name: 'Boulon de Roue',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Boulon_de_Roue.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-8',
              name: 'Bras de Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Bras_de_Suspension.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-9',
              name: 'Capteur ABS',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Capteur_ABS.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-10',
              name: 'Contrôle De Pression Des Pneumatiques',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Contrôle_De_Pression_Des_Pneumatiques.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-11',
              name: 'Coupelle dAmortisseur',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Coupelle_dAmortisseur.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-12',
              name: 'Douille pivot de direction',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Douille_pivot_de_direction.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-13',
              name: 'Ecartement Des Roues Élargi',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Ecartement_Des_Roues_Élargi.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-14',
              name: 'Kit DAssemblage Bras De Liaison',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Kit_DAssemblage_Bras_De_Liaison.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-15',
              name: 'Kit Réparation Biellette De Barre Stabilisatrice',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Kit_Réparation_Biellette_De_Barre_Stabilisatrice.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-16',
              name: 'Kit Réparation Rotule De Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Kit_Réparation_Rotule_De_Suspension.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-17',
              name: 'Kit Réparation Suspension De Roue',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Kit_Réparation_Suspension_De_Roue.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-18',
              name: 'Kit de Réparation Bras de Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Kit_de_Réparation_Bras_de_Suspension.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-19',
              name: 'Lame De Ressort',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Lame_De_Ressort.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-20',
              name: 'Moyeu De Roue',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Moyeu_De_Roue.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-21',
              name: 'Outils pour suspension',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Outils_pour_suspension.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-22',
              name: 'Pivot De Fusée',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Pivot_De_Fusée.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-23',
              name: 'Porte Fusée',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Porte_Fusée.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-24',
              name: 'Pâte dassemblage',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Pâte_dassemblage.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-25',
              name: 'Rotule Axiale',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Rotule_Axiale.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-26',
              name: 'Rotule De Direction',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Rotule_De_Direction.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-27',
              name: 'Rotule de Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Rotule_de_Suspension.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-28',
              name: 'Roulement Boîtier Du Roulement Des Roues',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Roulement_Boîtier_Du_Roulement_Des_Roues.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-29',
              name: 'Roulement De Roues',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Roulement_De_Roues.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-30',
              name: 'Silent Bloc de Barre Stabilisatrice',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Silent_Bloc_de_Barre_Stabilisatrice.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-31',
              name: 'Silent Bloc de Bras de Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Silent_Bloc_de_Bras_de_Suspension.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-32',
              name: 'Soufflet dAmortisseur & Butée Élastique Suspension',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Soufflet_dAmortisseur_&_Butée_Élastique_Suspension.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-33',
              name: 'Soufflet de Direction',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Soufflet_de_Direction.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-34',
              name: 'Support De Boite De Vitesse',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Support_De_Boite_De_Vitesse.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-35',
              name: 'Support Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Support_Moteur.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-36',
              name: 'Support dEssieu',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Support_dEssieu.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-37',
              name: 'Support suspension du stabilisateur',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Support_suspension_du_stabilisateur.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-38',
              name: 'Suspension de la cabine',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Suspension_de_la_cabine.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-39',
              name: 'Train Arriere',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Train_Arriere.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-40',
              name: 'Vis de correction des chutes',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Vis_de_correction_des_chutes.png',
              categoryId: '26',
            ),
            Subcategory(
              id: '26-41',
              name: 'Écrou bout dessieu',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_et_Bras/Écrou_bout_dessieu.png',
              categoryId: '26',
            ),
          ];

        case '27': // Suspension pneumatique
          return [
            Subcategory(
              id: '27-1',
              name: 'Compresseur Systeme DAir Comprimé DAdmission Moteur',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_pneumatique/Compresseur_Systeme_DAir_Comprimé_DAdmission_Moteur.png',
              categoryId: '27',
            ),
            Subcategory(
              id: '27-3',
              name: 'Relais correcteur dassiette',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_pneumatique/Relais_correcteur_dassiette.png',
              categoryId: '27',
            ),
            Subcategory(
              id: '27-4',
              name: 'Ressort pneumatique',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_pneumatique/Ressort_pneumatique.png',
              categoryId: '27',
            ),
            Subcategory(
              id: '27-5',
              name: 'Soufflet À Air Suspension Pneumatique',
              imagePath:
                  'assets/images/subcategoryImages/Suspension_pneumatique/Soufflet_À_Air_Suspension_Pneumatique.png',
              categoryId: '27',
            ),
          ];

        case '28': // Système d'Alimentation
          return [
            // Subcategory(
            //   id: '28-1',
            //   name: 'Accumulateur De Pression Carburant',
            //   imagePath:
            //       'assets/images/subcategoryImages/Système_d\'Alimentation/Accumulateur_De_Pression_Carburant.png',
            //   categoryId: '28',
            // ),
            Subcategory(
              id: '28-1',
              name: 'Accumulateur De Pression Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Accumulateur_De_Pression_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-2',
              name: 'Actuateur de ralenti',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Actuateur_de_ralenti.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-3',
              name: 'Additifs pour carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Additifs_pour_carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-4',
              name: 'Appareil de commande gestion moteur',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Appareil_de_commande_gestion_moteur.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-5',
              name: 'Boitier Papillon',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Boitier_Papillon.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-6',
              name: 'Bouchon de Réservoir de Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Bouchon_de_Réservoir_de_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-7',
              name: 'Boîtier De Filtres à Huile Joint',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Boîtier_De_Filtres_à_Huile__Joint.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-8',
              name: 'Capteur De Niveau De Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Capteur_De_Niveau_De_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-9',
              name: 'Capteur De Position Du Papillon',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Capteur_De_Position_Du_Papillon.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-10',
              name: 'Capteur Position De La Pédale',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Capteur_Position_De_La_Pédale.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-11',
              name: 'Capteur de Pression Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Capteur_de_Pression_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-12',
              name: 'Capteur de Température de Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Capteur_de_Température_de_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-13',
              name: 'Capteur de pression réservoir de carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Capteur_de_pression_réservoir_de_carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-14',
              name: 'Composants Du Carburateur',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Composants_Du_Carburateur.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-15',
              name: 'Composants du bouchon',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Composants_du_bouchon.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-16',
              name: 'Câble d\'Accélérateur',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Câble_d\'Accélérateur.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-17',
              name: 'Dispositif d\'arrêt système d\'injection',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Dispositif_d\'arrêt_système_d\'injection.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-18',
              name: 'Débitmètre d\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Débitmètre_d\'Air.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-19',
              name: 'Ecran Absorbant La Chaleur Injection',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Ecran_Absorbant_La_Chaleur_Injection.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-20',
              name: 'Filtre à Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Filtre_à_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-21',
              name: 'Flasque Carburateur',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Flasque_Carbureteur.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-22',
              name: 'Fluides échappement diesel AdBlue',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Fluides_échappement_diesel__AdBlue.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-23',
              name: 'Injecteurs',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Injecteurs.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-24',
              name:
                  'Interrupteur de température enrichissement démarrage à froid',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Interrupteur_de_température_enrichissement_démarrage_à_froid.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-25',
              name: 'Joint D\'Étanchéité Pompe À Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Joint_D\'Étanchéité_Pompe_À_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-26',
              name: 'Joint Injecteur',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Joint_Injecteur.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-27',
              name: 'Joint d\'étanchéité palpeur de réservoir',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Joint_d\'étanchéité_palpeur_de_réservoir.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-28',
              name: 'Joint d\'étanchéité pompe d\'injection',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Joint_d\'étanchéité_pompe_d\'injection.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-29',
              name: 'Joint d\'étanchéité tuyauterie de carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Joint_d\'étanchéité_tuyauterie_de_carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-30',
              name: 'Kit De Réparation Injecteur',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Kit_De_Réparation_Injecteur.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-31',
              name: 'Kit d\'assemblage pompe à carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Kit_d\'assemblage_pompe_à_carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-32',
              name: 'Kit de réparation carburateur',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Kit_de_réparation_carburateur.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-33',
              name: 'Outils pour système de carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Outils_pour_système_de_carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-34',
              name: 'Palpeur de niveau circuit de carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Palpeur_de_niveau_circuit_de_carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-35',
              name: 'Pompe Haute Pression',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Pompe_Haute_Pression.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-36',
              name: 'Pompe à Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Pompe_à_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-37',
              name: 'Pédale d\'accélérateur',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Pédale_d\'accélérateur.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-38',
              name: 'Rail De Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Rail_De_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-39',
              name: 'Relais de Pompe à Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Relais_de_Pompe_à_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-40',
              name: 'Régulateur De Pression Du Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Régulateur_De_Pression_Du_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-41',
              name: 'Régulateur de Ralenti',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Régulateur_de_Ralenti.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-42',
              name: 'Réservoir de Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Réservoir_de_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-43',
              name: 'Sonde Lambda',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Sonde_Lambda.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-44',
              name: 'Soupape De Ventilation De Réservoir Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Soupape_De_Ventilation_De_Réservoir_Carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-45',
              name: 'Soupape filtre à carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Soupape_filtre_à_carburant.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-46',
              name: 'Système d\'injection',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Système_d\'injection.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-47',
              name: 'Tuyau carburant de fuite',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Tuyau_carburant_de_fuite.png',
              categoryId: '28',
            ),
            Subcategory(
              id: '28-48',
              name: 'Élément d\'ajustage papillon des gaz',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Alimentation/Élément_d\'ajustage_papillon_des_gaz.png',
              categoryId: '28',
            ),
          ];

        case '29': // Système d'Allumage et Bougies de Préchauffage
          return [
            Subcategory(
              id: '29-1',
              name: 'Allumeur',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Allumeur.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-2',
              name: 'Appareil de commande gestion moteur',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Appareil_de_commande_gestion_moteur.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-3',
              name: 'Bobines d\'Allumage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Bobines_d\'Allumage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-4',
              name: 'Bougie De Préchauffage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Bougie_De_Préchauffage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-5',
              name: 'Bougies d\'Allumage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Bougies_d\'Allumage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-6',
              name: 'Boîte de dépression distibuteur d\'allumage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Boîte_de_dépression_distibuteur_d\'allumage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-7',
              name: 'Capteur Aac',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Capteur_Aac.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-8',
              name: 'Capteur De Cliquetis',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Capteur_De_Cliquetis.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-9',
              name: 'Capteur PMH',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Capteur_PMH.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-10',
              name: 'Chapeau pare poussière distributeur d\'allumage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Chapeau_pare_poussière_distributeur_d\'allumage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-11',
              name: 'Doigt d\'Allumeur',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Doigt_d\'Allumeur.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-12',
              name: 'Faisceau d\'Allumage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Faisceau_d\'Allumage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-13',
              name: 'Fiche Bougie D\'Allumage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Fiche_Bougie_D\'Allumage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-14',
              name: 'Joint De Carter De Distribution',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Joint_De_Carter_De_Distribution.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-15',
              name: 'Kit réparation distributeur d\'allumage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Kit_réparation_distributeur_d\'allumage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-16',
              name: 'Liquides de démarrage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Liquides_de_démarrage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-17',
              name: 'Module d\'Allumage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Module_d\'Allumage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-18',
              name: 'Outils allumage préchauffage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Outils_allumage__préchauffage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-19',
              name: 'Ruban électrique liquide',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Ruban_électrique_liquide.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-20',
              name: 'Temporisateur de Préchauffage',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Temporisateur_de_Préchauffage.png',
              categoryId: '29',
            ),
            Subcategory(
              id: '29-21',
              name: 'Tête De Delco',
              imagePath:
                  'assets/images/subcategoryImages/Système_d\'Allumage_et_Bougies_de_Préchauffage/Tête_De_Delco.png',
              categoryId: '29',
            ),
          ];

        case '30': // Système électrique
          return [
            Subcategory(
              id: '30-1',
              name: 'Alternateur',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Alternateur.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-2',
              name: 'Ampoule De Feu Clignotant',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Ampoule_De_Feu_Clignotant.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-3',
              name: 'Ampoule Feu Eclaireur De Plaque',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Ampoule_Feu_Eclaireur_De_Plaque.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-4',
              name: 'Ampoule Pour Feux Arrières',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Ampoule_Pour_Feux_Arrières.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-5',
              name: 'Ampoule Pour Projecteur Antibrouillard',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Ampoule_Pour_Projecteur_Antibrouillard.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-6',
              name: 'Ampoule Pour Projecteur Principal',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Ampoule_Pour_Projecteur_Principal.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-7',
              name: 'Ampoule Projecteur Longue Portée',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Ampoule_Projecteur_Longue_Portée.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-8',
              name: 'Ampoules Pour Feux De Stop',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Ampoules_Pour_Feux_De_Stop.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-9',
              name: 'Antennes',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Antennes.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-10',
              name: 'Anti brouillard',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Anti_brouillard.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-11',
              name: 'Antibrouillard Arriere',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Antibrouillard_Arriere.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-12',
              name: 'Appareil de commande chauffage ventilation',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Appareil_de_commande_chauffage_ventilation.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-13',
              name: 'Appareil de commande système d\'éclairage',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Appareil_de_commande_système_d\'éclairage.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-14',
              name: 'Bague Abs',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Bague_Abs.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-15',
              name: 'Balais démarreur',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Balais_démarreur.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-16',
              name: 'Batterie',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Batterie.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-17',
              name: 'Boîte à fusibles',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Boîte_à_fusibles.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-18',
              name: 'Capteur ABS',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Capteur_ABS.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-19',
              name: 'Capteur Aac',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Capteur_Aac.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-20',
              name: 'Capteur De Position Du Papillon',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Capteur_De_Position_Du_Papillon.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-21',
              name: 'Capteur Niveau d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Capteur_Niveau_d\'Huile.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-22',
              name: 'Capteur PMH',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Capteur_PMH.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-23',
              name: 'Capteur Pression D\'Admission',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Capteur_Pression_D\'Admission.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-24',
              name: 'Capteur de Pression Différentielle',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Capteur_de_Pression_Différentielle.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-25',
              name: 'Capteur de Pression de Suralimentation',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Capteur_de_Pression_de_Suralimentation.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-26',
              name: 'Capteur de Température des Gaz d\'Échappement',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Capteur_de_Température_des_Gaz_d\'Échappement.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-27',
              name: 'Capteurs de Recul',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Capteurs_de_Recul.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-28',
              name: 'Clignotant',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Clignotant.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-29',
              name: 'Colonne De Direction Direction Assistée Électrique',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Colonne_De_Direction_Direction_Assistée_Électrique.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-30',
              name: 'Commodo de Phare',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Commodo_de_Phare.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-31',
              name: 'Commutateur Sous Volant',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Commutateur_Sous_Volant.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-32',
              name: 'Composant Alternateur',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Composant_Alternateur.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-33',
              name: 'Composants De Feu Arrière',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Composants_De_Feu_Arrière.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-34',
              name: 'Composants Des Projecteurs Principaux',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Composants_Des_Projecteurs_Principaux.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-35',
              name: 'Composants Pour Projecteur Antibrouillard',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Composants_Pour_Projecteur_Antibrouillard.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-36',
              name: 'Contacteur De Feux Stop',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Contacteur_De_Feux_Stop.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-37',
              name: 'Contacteur Leve Vitre',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Contacteur_Leve_Vitre.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-38',
              name: 'Contacteur de Feu de Recul',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Contacteur_de_Feu_de_Recul.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-39',
              name: 'Contrôle De Pression Des Pneumatiques',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Contrôle_De_Pression_Des_Pneumatiques.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-40',
              name: 'Contôle chauffage du siège',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Contôle_chauffage_du_siège.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-41',
              name: 'Câble Flexible De Commande De Compteur',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Câble_Flexible_De_Commande_De_Compteur.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-42',
              name: 'Débitmètre d\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Débitmètre_d\'Air.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-43',
              name: 'Démarreur',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Démarreur.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-44',
              name: 'Eclairage De Plaque d\'Immatriculation',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Eclairage_De_Plaque_d\'Immatriculation.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-45',
              name: 'Eclairage De l\'Habitacle',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Eclairage_De_l\'Habitacle.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-46',
              name: 'Electrovanne De Commande Arbre a cames',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Electrovanne_De_Commande_Arbre_a_cames.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-47',
              name: 'Embrayage À Roue Libre Démarreur',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Embrayage_À_Roue_Libre_Démarreur.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-48',
              name: 'Faisceau Éléctrique D\'Attelage',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Faisceau_Éléctrique_D\'Attelage.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-49',
              name: 'Fermeture Centralisée',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Fermeture_Centralisée.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-50',
              name: 'Feu Arrière',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Feu_Arrière.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-51',
              name: 'Feu Diurne',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Feu_Diurne.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-52',
              name: 'Feu Stop Additionnel',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Feu_Stop_Additionnel.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-53',
              name: 'Feu de Position',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Feu_de_Position.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-54',
              name: 'Fusible',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Fusible.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-55',
              name: 'Gyrophare',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Gyrophare.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-56',
              name: 'Interrupteur D\'Allumage De Démarreur',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Interrupteur_D\'Allumage_De_Démarreur.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-57',
              name: 'Interrupteur de Température ventilateur de radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Interrupteur_de_Température_ventilateur_de_radiateur.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-58',
              name: 'Jeu De Câbles',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Jeu_De_Câbles.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-59',
              name: 'Klaxon',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Klaxon.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-60',
              name: 'Lève Vitre',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Lève_Vitre.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-61',
              name: 'Moteur Lève Vitre',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Moteur_Lève_Vitre.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-62',
              name: 'Moteur d\'Essuie Glace',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Moteur_d\'Essuie_Glace.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-63',
              name: 'Multifunctional relay',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Multifunctional_relay.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-64',
              name: 'Outils pour électricité automobile',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Outils_pour_électricité_automobile.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-65',
              name: 'Phare Avant',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Phare_Avant.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-66',
              name: 'Phares Au Xénon',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Phares_Au_Xénon.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-67',
              name: 'Pompe De Lave Glace',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Pompe_De_Lave_Glace.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-68',
              name: 'Poulie d\'Alternateur',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Poulie_d\'Alternateur.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-69',
              name: 'Pressostat d\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Pressostat_d\'Huile.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-70',
              name: 'Pressostat de Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Pressostat_de_Climatisation.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-71',
              name: 'Produits de nettoyage de contacts électriques',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Produits_de_nettoyage_de_contacts_électriques.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-72',
              name: 'Relais de Pompe à Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Relais_de_Pompe_à_Carburant.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-73',
              name: 'Resistance Pulseur d\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Resistance_Pulseur_d\'Air.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-74',
              name: 'Ruban électrique liquide',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Ruban_électrique_liquide.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-75',
              name: 'Régulateur De Pression Du Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Régulateur_De_Pression_Du_Carburant.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-76',
              name: 'Régulateur d\'Alternateur',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Régulateur_d\'Alternateur.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-77',
              name: 'Régulateur de Ralenti',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Régulateur_de_Ralenti.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-78',
              name: 'Solénoïde De Démarreur',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Solénoïde_De_Démarreur.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-79',
              name: 'Sonde Lambda',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Sonde_Lambda.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-80',
              name: 'Sonde de Température Liquide de Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Sonde_de_Température_Liquide_de_Refroidissement.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-81',
              name: 'Temporisateur de Préchauffage',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Temporisateur_de_Préchauffage.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-82',
              name: 'Témoin d\'Usure Plaquettes De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Témoin_d\'Usure_Plaquettes_De_Frein.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-83',
              name: 'Électrovanne De Turbo',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Électrovanne_De_Turbo.png',
              categoryId: '30',
            ),
            Subcategory(
              id: '30-84',
              name: 'Élément d\'Ajustage Correcteur de Portée Lumineuse',
              imagePath:
                  'assets/images/subcategoryImages/Système_électrique/Élément_d\'Ajustage_Correcteur_de_Portée_Lumineuse.png',
              categoryId: '30',
            ),
          ];

        case '31': // Tuning
          return [
            Subcategory(
              id: '31-1',
              name: 'Boîtier additionnel',
              imagePath:
                  'assets/images/subcategoryImages/Tuning/Boîtier_additionnel.png',
              categoryId: '31',
            ),
            Subcategory(
              id: '31-2',
              name: 'Calandre tuning',
              imagePath:
                  'assets/images/subcategoryImages/Tuning/Calandre_tuning.png',
              categoryId: '31',
            ),
            Subcategory(
              id: '31-3',
              name: 'Disque de frein sport',
              imagePath:
                  'assets/images/subcategoryImages/Tuning/Disque_de_frein_sport.png',
              categoryId: '31',
            ),
            Subcategory(
              id: '31-4',
              name: 'Disque de freins de haute performance',
              imagePath:
                  'assets/images/subcategoryImages/Tuning/Disque_de_freins_de_haute_performance.png',
              categoryId: '31',
            ),
            Subcategory(
              id: '31-5',
              name: 'Ecartement Des Roues Élargi',
              imagePath:
                  'assets/images/subcategoryImages/Tuning/Ecartement_Des_Roues_Élargi.png',
              categoryId: '31',
            ),
            Subcategory(
              id: '31-6',
              name: 'Embrayage renforcé',
              imagePath:
                  'assets/images/subcategoryImages/Tuning/Embrayage_renforcé.png',
              categoryId: '31',
            ),
            Subcategory(
              id: '31-7',
              name: 'Filtre à air sport',
              imagePath:
                  'assets/images/subcategoryImages/Tuning/Filtre_à_air_sport.png',
              categoryId: '31',
            ),
            Subcategory(
              id: '31-8',
              name: 'Garnitures de freins de haute performance',
              imagePath:
                  'assets/images/subcategoryImages/Tuning/Garnitures_de_freins_de_haute_performance.png',
              categoryId: '31',
            ),
            Subcategory(
              id: '31-9',
              name: 'Plaquette de frein sport',
              imagePath:
                  'assets/images/subcategoryImages/Tuning/Plaquette_de_frein_sport.png',
              categoryId: '31',
            ),
            Subcategory(
              id: '31-10',
              name: 'Suspension sport',
              imagePath:
                  'assets/images/subcategoryImages/Tuning/Suspension_sport.png',
              categoryId: '31',
            ),
            Subcategory(
              id: '31-11',
              name: 'Échappement sport',
              imagePath:
                  'assets/images/subcategoryImages/Tuning/Échappement_sport.png',
              categoryId: '31',
            ),
          ];

        case '32': // Turbocompresseur
          return [
            Subcategory(
              id: '32-1',
              name: 'Bague d’etancheite gaine de suralimentation',
              imagePath:
                  'assets/images/subcategoryImages/Turbocompresseur/Bague_d’etancheite_gaine_de_suralimentation.png',
              categoryId: '32',
            ),
            Subcategory(
              id: '32-2',
              name: 'Capteur de Pression de Suralimentation',
              imagePath:
                  'assets/images/subcategoryImages/Turbocompresseur/Capteur_de_Pression_de_Suralimentation.png',
              categoryId: '32',
            ),
            Subcategory(
              id: '32-3',
              name: 'Conduite d\'Huile Turbocompresseur',
              imagePath:
                  'assets/images/subcategoryImages/Turbocompresseur/Conduite_d\'Huile_Turbocompresseur.png',
              categoryId: '32',
            ),
            Subcategory(
              id: '32-4',
              name: 'Gaine De Suralimentation',
              imagePath:
                  'assets/images/subcategoryImages/Turbocompresseur/Gaine_De_Suralimentation.png',
              categoryId: '32',
            ),
            Subcategory(
              id: '32-5',
              name: 'Intercooler',
              imagePath:
                  'assets/images/subcategoryImages/Turbocompresseur/Intercooler.png',
              categoryId: '32',
            ),
            Subcategory(
              id: '32-6',
              name: 'Joint De Turbocompresseur',
              imagePath:
                  'assets/images/subcategoryImages/Turbocompresseur/Joint_De_Turbocompresseur.png',
              categoryId: '32',
            ),
            Subcategory(
              id: '32-7',
              name: 'Kit de Montage Compresseur',
              imagePath:
                  'assets/images/subcategoryImages/Turbocompresseur/Kit_de_Montage_Compresseur.png',
              categoryId: '32',
            ),
            Subcategory(
              id: '32-8',
              name: 'Turbocompresseur',
              imagePath:
                  'assets/images/subcategoryImages/Turbocompresseur/Turbocompresseur.png',
              categoryId: '32',
            ),
            Subcategory(
              id: '32-9',
              name: 'Valve D\'Air De Circulation Compresseur',
              imagePath:
                  'assets/images/subcategoryImages/Turbocompresseur/Valve_D\'Air_De_Circulation_Compresseur.png',
              categoryId: '32',
            ),
            Subcategory(
              id: '32-10',
              name: 'Électrovanne De Turbo',
              imagePath:
                  'assets/images/subcategoryImages/Turbocompresseur/Électrovanne_De_Turbo.png',
              categoryId: '32',
            ),
          ];

        case '33': // Tuyaux et Conduites
          return [
            Subcategory(
              id: '33-1',
              name: 'Bague d\'étanchéité gaine de suralimentation',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Bague_d\'étanchéité_gaine_de_suralimentation.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-2',
              name: 'Bride De Liquide De Refroidissement',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Bride_De_Liquide_De_Refroidissement.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-3',
              name: 'Conduit D\'Embrayage',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Conduit_D\'Embrayage.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-4',
              name: 'Conduite d\'Huile Turbocompresseur',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Conduite_d\'Huile_Turbocompresseur.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-5',
              name: 'Conduite de Climatisation',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Conduite_de_Climatisation.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-6',
              name: 'Conduites De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Conduites_De_Frein.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-7',
              name: 'Durite D\'Admission D\'Air',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Durite_D\'Admission_D\'Air.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-8',
              name: 'Durite Servo Frein',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Durite_Servo_Frein.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-9',
              name: 'Durite de Carburant',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Durite_de_Carburant.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-10',
              name: 'Durite de Direction Assistée',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Durite_de_Direction_Assistée.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-11',
              name: 'Durite de Radiateur',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Durite_de_Radiateur.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-12',
              name: 'Flexible Aération De La Housse De Culasse',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Flexible_Aération_De_La_Housse_De_Culasse.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-13',
              name: 'Flexible De Frein',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Flexible_De_Frein.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-14',
              name: 'Gaine De Suralimentation',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Gaine_De_Suralimentation.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-15',
              name: 'Manche batterie chauffante chauffage',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Manche_batterie_chauffante_chauffage.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-16',
              name: 'Tuyau Reniflard D\'Huile',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Tuyau_Reniflard_D\'Huile.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-17',
              name: 'Tuyau carburant de fuite',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Tuyau_carburant_de_fuite.png',
              categoryId: '33',
            ),
            Subcategory(
              id: '33-18',
              name: 'Tuyau de ventilation réservoir de carburant',
              imagePath:
                  'assets/images/subcategoryImages/Tuyaux_et_Conduites/Tuyau_de_ventilation_réservoir_de_carburant.png',
              categoryId: '33',
            ),
          ];

        case '34': // Éléments de fixation
          return [
            Subcategory(
              id: '34-1',
              name: 'Boulons',
              imagePath:
                  'assets/images/subcategoryImages/Éléments_de_fixation/Boulons.png',
              categoryId: '34',
            ),
            Subcategory(
              id: '34-2',
              name: 'Clips de serrage',
              imagePath:
                  'assets/images/subcategoryImages/Éléments_de_fixation/Clips_de_serrage.png',
              categoryId: '34',
            ),
            Subcategory(
              id: '34-3',
              name: 'Durites tuyaux universels',
              imagePath:
                  'assets/images/subcategoryImages/Éléments_de_fixation/Durites_tuyaux_universels.png',
              categoryId: '34',
            ),
            Subcategory(
              id: '34-4',
              name: 'Joints bagues d\'étanchéité universels',
              imagePath:
                  'assets/images/subcategoryImages/Éléments_de_fixation/Joints_bagues_d\'étanchéité_universels.png',
              categoryId: '34',
            ),
            Subcategory(
              id: '34-5',
              name: 'Rivets',
              imagePath:
                  'assets/images/subcategoryImages/Éléments_de_fixation/Rivets.png',
              categoryId: '34',
            ),
            Subcategory(
              id: '34-6',
              name: 'Écrous',
              imagePath:
                  'assets/images/subcategoryImages/Éléments_de_fixation/Écrous.png',
              categoryId: '34',
            ),
          ];
        default:
          return [];
      }
    } catch (e) {
      debugPrint('Error getting subcategories for category $categoryId: $e');
      return [];
    }
  }

  // Price range
  static const double minPrice = 0.0;
  static const double maxPrice = 100000.0;

  // Year range from 1960 to 2025
  static List<String> get years {
    return List.generate(66, (index) => (2025 - index).toString())
        .where((year) => int.parse(year) >= 1960)
        .toList();
  }

  // Mileage ranges
  static const List<String> mileageRanges = [
    '0-10,000 km',
    '10,001-30,000 km',
    '30,001-50,000 km',
    '50,001-80,000 km',
    '80,001-120,000 km',
    '120,000+ km',
  ];

  static const List<String> garageCities = [
    'Adrar',
    'Chlef',
    'Laghouat',
    'Oum El Bouaghi',
    'Batna',
    'Béjaïa',
    'Biskra',
    'Béchar',
    'Blida',
    'Bouira',
    'Tamanrasset',
    'Tébessa',
    'Tlemcen',
    'Tiaret',
    'Tizi Ouzou',
    'Algiers',
    'Djelfa',
    'Jijel',
    'Sétif',
    'Saïda',
    'Skikda',
    'Sidi Bel Abbès',
    'Annaba',
    'Guelma',
    'Constantine',
    'Médéa',
    'Mostaganem',
    'M’Sila',
    'Mascara',
    'Ouargla',
    'Oran',
    'El Bayadh',
    'Illizi',
    'Bordj Bou Arréridj',
    'Boumerdès',
    'El Tarf',
    'Tindouf',
    'Tissemsilt',
    'El Oued',
    'Khenchela',
    'Souk Ahras',
    'Tipaza',
    'Mila',
    'Aïn Defla',
    'Naâma',
    'Aïn Témouchent',
    'Ghardaïa',
    'Relizane',
    'Timimoun',
    'Bordj Badji Mokhtar',
    'Ouled Djellal',
    'Béni Abbès',
    'In Salah',
    'In Guezzam',
    'Touggourt',
    'Djanet',
    'El Mghair',
    'El Meniaa',
  ];

  // Available services for garage filtering
  static const List<String> garageServices = [
    'Body Repair Technician',
    'Automotive Diagnostic',
    'Mechanic',
    'Tire Technician',
  ];

  // Price ranges in Algerian Dinar (DZD)
  static const List<String> priceRangesDZD = [
    '100,000 DZD',
    '200,000 DZD',
    '300,000 DZD',
    '400,000 DZD',
    '500,000 DZD',
    '600,000 DZD',
    '700,000 DZD',
    '800,000 DZD',
    '900,000 DZD',
    '1,000,000 DZD',
    '1,500,000 DZD',
    '2,000,000 DZD',
    '2,500,000 DZD',
    '3,000,000 DZD',
    '3,500,000 DZD',
    '4,000,000 DZD',
    '4,500,000 DZD',
    '5,000,000 DZD',
    '6,000,000 DZD',
    '7,000,000 DZD',
    '8,000,000 DZD',
    '9,000,000 DZD',
    '10,000,000 DZD',
    '10,000,000+ DZD'
  ];

  // Helper methods to convert between display and numeric values
  static int priceStringToInt(String priceStr) {
    final cleanStr = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanStr) ?? 0;
  }

  static String intToPriceString(int value) {
    if (value >= 10000000) return '10,000,000+ DZD';
    final formatter = NumberFormat('#,###');
    return '${formatter.format(value)} DZD';
  }

  // Get list of brands
  static List<String> get brands => brandModels.keys.toList();

  // Get models for a specific brand
  static List<String> getModelsForBrand(String brand) {
    return brandModels[brand] ?? [];
  }

  // Purchase types
  static const List<String> purchaseTypes = [
    'sell',
    'Rent',
  ];

  // Transmission types
  static const List<String> transmissions = [
    'Automatic',
    'Manual',
    'Semi-Automatic',
    'CVT',
    'Dual-Clutch',
  ];

  // Fuel types
  static const List<String> fuelTypes = [
    'Gasoline',
    'Diesel',
    'Electric',
    'Hybrid',
    'Plug-in Hybrid',
    'LPG',
    'CNG',
    'Hydrogen',
  ];

  // Car body types
  static const List<String> bodyTypes = [
    'Sedan',
    'SUV',
    'Truck',
    'Van',
    'Wagon',
    'Convertible',
    'Coupe',
    'Sports Car',
    'Hatchback',
    'Minivan',
    'Pickup',
    'Crossover',
    'Luxury',
    'Electric Vehicle',
  ];

  // Colors
  static const List<String> colors = [
    'White',
    'Black',
    'Silver',
    'Gray',
    'Red',
    'Blue',
    'Brown',
    'Green',
    'Beige',
    'Orange',
    'Gold',
    'Yellow',
    'Purple',
  ];

  // Number of doors
  static const List<String> doorCounts = [
    '2',
    '3',
    '4',
    '5+',
  ];

  // Number of seats
  static const List<String> seatCounts = [
    '2',
    '4',
    '5',
    '6',
    '7',
    '8+',
  ];

  // Drive types
  static const List<String> driveTypes = [
    'Front-Wheel Drive (FWD)',
    'Rear-Wheel Drive (RWD)',
    'All-Wheel Drive (AWD)',
    'Four-Wheel Drive (4WD)',
  ];

  // Engine sizes (in liters)
  static const List<String> engineSizes = [
    '1.0L',
    '1.2L',
    '1.4L',
    '1.6L',
    '1.8L',
    '2.0L',
    '2.2L',
    '2.4L',
    '2.5L',
    '3.0L',
    '3.5L',
    '4.0L',
    '5.0L',
    '5.7L',
    '6.0L+',
  ];

  // Cities
  static const List<String> cities = [
    'Tunis',
    'Sfax',
    'Sousse',
    'Kairouan',
    'Bizerte',
    'Gabès',
    'Ariana',
    'Gafsa',
    'Monastir',
    'Ben Arous',
    'Nabeul',
    'Béja',
    'Jendouba',
    'Kasserine',
    'Kébili',
    'Le Kef',
    'Mahdia',
    'Manouba',
    'Médenine',
    'Sidi Bouzid',
    'Siliana',
    'Tataouine',
    'Tozeur',
    'Zaghouan',
  ];

  // Features
  static const List<String> features = [
    'Air Conditioning',
    'Navigation System',
    'Bluetooth',
    'Backup Camera',
    'Leather Seats',
    'Sunroof/Moonroof',
    'Heated Seats',
    'Third Row Seating',
    'Alloy Wheels',
    'Keyless Entry',
    'Push Button Start',
    'Blind Spot Monitoring',
    'Lane Keeping Assist',
    'Adaptive Cruise Control',
    'Apple CarPlay',
    'Android Auto',
    'Premium Sound System',
    'Dual Zone A/C',
    'Panoramic Roof',
    'Towing Package',
  ];
}

// Car brands with their models
const Map<String, List<String>> brandModels = {
  'Abarth': [
    '1000 TC',
    '1000 TCR',
    '124 Spider',
    '131 Rally',
    '2000 Sport',
    '204 A',
    '205 Vignale Berlinetta',
    '2200 Coupe',
    '3000 Sport Prototipo',
    '500',
    '595',
    '695',
    '750',
    '750 Record Monza',
    '750 Zagato',
    'Grande Punto',
    'OT 1300',
    'OT 1600',
    'Punto Evo',
    'Ritmo 130 TC',
    'Simca 1300 GT',
    'Stilo',
    'Other',
  ],
  'Acura': [
    'ILX',
    'MDX',
    'NSX',
    'RDX',
    'RLX',
    'TLX',
    'TSX',
    'ZDX',
    'CL',
    'CSX (Canada only)',
    'EL (Canada only)',
    'Integra',
    'Legend',
    'RL',
    'RSX',
    'SLX',
    'TL',
    'Vigor',
    'Other',
  ],
  'Alfa Romeo': [
    '145',
    '146',
    '147',
    '155',
    '156',
    '159',
    '164',
    '166',
    '1750 Berlina',
    '1900',
    '2600',
    '33',
    '4C',
    '75',
    '8C Competizione',
    '90',
    'Alfasud',
    'Alfetta',
    'Brera',
    'Giulia',
    'Giulietta',
    'GT',
    'GTV',
    'GTV6',
    'MiTo',
    'Montreal',
    'RZ (Roadster Zagato)',
    'Spider',
    'Stelvio',
    'SZ (Sprint Zagato)',
    'Tonale',
    'Other',
  ],
  'Aston Martin': [
    'AMR21 (Formula One car)',
    'Bulldog',
    'Cygnet',
    'DB11',
    'DB2',
    'DB2/4',
    'DB3',
    'DB4',
    'DB5',
    'DB6',
    'DB7',
    'DB9',
    'DBX (SUV)',
    'DBS',
    'Lagonda',
    'Lagonda Taraf',
    'One-77',
    'Rapide',
    'Valhalla',
    'Valkyrie',
    'Vanquish',
    'Vantage',
    'V12 Speedster',
    'Virage',
    'Vulcan',
    'Other',
  ],
  'Audi': [
    'A1',
    'A1 Sportback',
    'A2',
    'A3',
    'A3 Allstreet',
    'A3 Berline',
    'A3 Cabriolet',
    'A3 Limousine',
    'A3 Sportback',
    'A3 TDI',
    'A4',
    'A4 Allroad',
    'A4 Avant',
    'A4 Cabriolet',
    'A4 Hybrid',
    'A5',
    'A5 Cabriolet',
    'A5 Sportback',
    'A6',
    'A6 Allroad',
    'A6 Avant',
    'A6 Plug-in Hybrid',
    'A6 Sedan',
    'A6 TDI',
    'A6 40 TDI',
    'A7',
    'A7 Allroad',
    'A7 Hybrid',
    'A7 Sportback',
    'A8',
    'A8 Hybrid',
    'A8 L',
    'A8 L W12',
    'A8 Sedan',
    'A8 TDI',
    'Q2',
    'Q3',
    'Q3 Sportback',
    'Q3 e-tron',
    'Q4',
    'Q4 e-tron',
    'Q5',
    'Q5 40 TFSI',
    'Q5 55 TFSI e',
    'Q5 Plug-in Hybrid',
    'Q5 Sportback',
    'Q5 TDI',
    'Q7',
    'Q7 60 TFSI e',
    'Q7 Plug-in Hybrid',
    'Q7 TDI',
    'Q7 e-tron',
    'Q8',
    'Q8 Plug-in Hybrid',
    'Q8 TDI',
    'Q8 e-tron',
    'R8',
    'R8 Spyder',
    'R8 V10',
    'R8 V10 Spyder',
    'RS Q3',
    'RS Q5',
    'RS Q7',
    'RS Q8',
    'RS3',
    'RS3 Sportback',
    'RS4',
    'RS4 Avant',
    'RS5',
    'RS5 Cabriolet',
    'RS5 Coupe',
    'RS5 Sportback',
    'RS6',
    'RS6 Avant',
    'RS6 Avant Plus',
    'RS7',
    'RS7 Sportback',
    'S1',
    'S3',
    'S3 Sportback',
    'S4',
    'S4 Avant',
    'S4 Sedan',
    'S5',
    'S5 Cabriolet',
    'S5 Sportback',
    'S6',
    'S6 Avant',
    'S6 Sedan',
    'S7',
    'S7 Sportback',
    'S8',
    'S8 Plus',
    'S8 Sedan',
    'SQ2',
    'SQ3',
    'SQ5',
    'SQ7',
    'SQ8',
    'TT',
    'TTS',
    'V8',
    'e-tron',
    'e-tron GT',
    '100',
    '200',
    '80',
    '90',
    'other',
  ],
  'Bentley': [
    'Azure',
    'Bentayga',
    'Brooklands',
    'Continental GT',
    'Flying Spur',
    'Mulsanne',
    'Other',
  ],
  'BMW': [
    '1 Series',
    '1 Series M',
    '2 Series',
    '2 Series M',
    '3 Series',
    '3 Series GT',
    '3 Series M',
    '4 Series',
    '4 Series Gran Coupe',
    '5 Series',
    '5 Series GT',
    '530d',
    '530e',
    '530i',
    '6 Series',
    '6 Series Gran Turismo',
    '7 Series',
    '7 Series LWB',
    '740Li',
    '740d',
    '740i',
    '745e',
    '8 Series',
    '8 Series Gran Coupe',
    'M1',
    'M2',
    'M240i',
    'M3',
    'M340i',
    'M4',
    'M440i',
    'M5',
    'M6',
    'M7',
    'M8',
    'X1',
    'X2',
    'X3',
    'X3 M',
    'X3 M40i',
    'X4',
    'X4 M',
    'X4 M40i',
    'X5',
    'X5 M',
    'X5 xDrive45e',
    'X6',
    'X6 M',
    'X7',
    'Z4',
    'Z8',
    'i3',
    'i4',
    'i4 M50',
    'i8',
    'iX',
    'iX3',
    'other',
  ],
  'Bugatti': [
    'Bolide',
    'Centodieci',
    'Chiron',
    'Divo',
    'Veyron',
    'Other',
  ],
  'Buick': [
    'Cascada',
    'Enclave',
    'Encore',
    'Encore GX',
    'Envision',
    'LaCrosse',
    'Regal',
    'Other',
  ],
  'BYD': [
    'Atto 3',
    'Dolphin',
    'E1',
    'E2',
    'E3',
    'E5',
    'E6',
    'e6',
    'F0',
    'F3',
    'F3 DM',
    'F3R',
    'F5',
    'F6',
    'F7',
    'G3',
    'G5',
    'G6',
    'Han',
    'L3',
    'M6',
    'Qin',
    'Qin Pro',
    'S6',
    'S7',
    'Song',
    'Song Max',
    'Song Pro',
    'Tang',
    'Yuan',
    'Yuan Pro',
    'other',
  ],
  'Cadillac': [
    'ATS',
    'CT4',
    'CT5',
    'CT6',
    'CTS',
    'ELR',
    'Escalade',
    'SRX',
    'XT4',
    'XT5',
    'XT6',
    'Other',
  ],
  'Chevrolet': [
    'Avalanche',
    'Aveo 4 doors',
    'Aveo 5 doors',
    'Blazer',
    'Blazer RS',
    'Bolt EV',
    'Bolt EUV',
    'Camaro',
    'Camaro LT',
    'Camaro SS',
    'Camaro ZL1',
    'Captiva',
    'Cobalt',
    'Colorado',
    'Colorado ZR2',
    'Corvette c1',
    'Corvette c2',
    'Corvette c3',
    'Corvette c4',
    'Corvette c5',
    'Corvette Stingray',
    'CMP',
    'Cruze',
    'Equinox',
    'Express',
    'Express 3500',
    'HHR',
    'Impala',
    'Impala LTZ',
    'Impala Premier',
    'Malibu',
    'Malibu Hybrid',
    'Malibu Premier',
    'Monte Carlo',
    'Optra',
    'Orlando',
    'Rezzo',
    'Sail 5 doors',
    'Silverado 1500',
    'Silverado 2500HD',
    'Silverado 3500HD',
    'Silverado 4500HD',
    'Silverado High Country',
    'Silverado Trail Boss',
    'Silverado Z71',
    'Sonic',
    'Sonic LTZ',
    'Sonic RS',
    'Spark',
    'Spark EV',
    'Suburban',
    'Suburban LTZ',
    'Suburban RST',
    'Tahoe',
    'Tahoe RST',
    'Traverse',
    'Traverse High Country',
    'Traverse RS',
    'Trax',
    'Volt',
    'Other',
  ],
  'Chrysler': [
    '200',
    '300',
    'Pacifica',
    'PT Cruiser',
    'Sebring',
    'Voyager',
    'Other',
  ],
  'Citroën': [
    '2CV',
    '3CV',
    'Aircross Concept',
    'Ami',
    'AX',
    'Berlingo',
    'Berlingo Multispace',
    'Berlingo XL',
    'BX',
    'C1',
    'C1 Airscape',
    'C2',
    'C3',
    'C3 Aircross',
    'C3 Cabrio',
    'C3 Comfort',
    'C3 Electric',
    'C3 Flair',
    'C3 GT Line',
    'C3 Picasso',
    'C3 Pluriel',
    'C3 PureTech',
    'C3 Red Edition',
    'C3 Shine',
    'C3 Supermini',
    'C3 Turbo',
    'C3 Urban Ride',
    'C3 WRC',
    'C4',
    'C4 Aircross',
    'C4 Aircross EV',
    'C4 BlueHDI',
    'C4 Cactus',
    'C4 Cactus 4x4',
    'C4 Cactus BlueHDi',
    'C4 Cactus Feel',
    'C4 Cactus Rip Curl',
    'C4 Cactus Shine',
    'C4 Cactus WRC',
    'C4 Cross',
    'C4 DS',
    'C4 E-HDi',
    'C4 Electric',
    'C4 Grand',
    'C4 Grand Picasso',
    'C4 Grand Picasso Flair',
    'C4 Grand Xperience',
    'C4 Piccadilly',
    'C4 Sedan',
    'C4 Spacetourer',
    'C4 WRC',
    'C5',
    'C5 Aircross',
    'C5 Aircross Hybrid',
    'C5 Break',
    'C5 CrossTourer',
    'C5 HDi',
    'C5 Hybrid',
    'C5 Hybrid4',
    'C5 Premium',
    'C5 Tourer',
    'C5 Tourer HDi',
    'C5 X',
    'C6',
    'C6 Hybrid',
    'C8',
    'C-Zero',
    'CX',
    'DS3',
    'DS3 Cabrio',
    'DS3 Cabrio Racing',
    'DS3 Racing',
    'DS3 WRC',
    'DS4',
    'DS4 Crossback',
    'DS5',
    'DS7 Crossback',
    'DS9',
    'Grand C4 Picasso',
    'Grand C4 Picasso 7-seat',
    'Jumper',
    'Jumper Van',
    'LNA',
    'Nemo',
    'Picasso',
    'Saxo',
    'Spacetourer',
    'Traction Avant',
    'Xantia',
    'Xsara',
    'Xsara Picasso',
    'Xsara VTS',
    'Other',
  ],
  'Cupra': [
    'Ateca',
    'Ateca Cupra',
    'Born',
    'Born e-Boost',
    'Cupra Ateca FR',
    'Cupra Ateca VZ',
    'Cupra Ateca VZ Edition',
    'Cupra Formentor VZ',
    'Cupra Formentor VZ Edition',
    'Cupra Formentor VZ Performance',
    'Cupra Formentor VZ4',
    'Cupra Formentor VZ5',
    'Cupra Formentor VZ5 Edition',
    'Cupra Formentor e-Hybrid',
    'Cupra Formentor TDI',
    'Cupra Formentor Concept',
    'Cupra Leon',
    'Cupra Leon 290',
    'Cupra Leon 300',
    'Cupra Leon Competición',
    'Cupra Leon Cupra',
    'Cupra Leon Estate',
    'Cupra Leon Sportstourer',
    'Cupra Leon TCR',
    'Cupra Leon VZ',
    'Cupra Leon VZ Edition',
    'Cupra R',
    'Cupra R ST',
    'Cupra R Variant',
    'Cupra Tavascan Concept',
    'Cupra UrbanRebel',
    'Formentor',
    'Formentor e-Hybrid',
    'Formentor TDI',
    'Formentor VZ',
    'Formentor VZ5',
    'Ibiza',
    'Ibiza Cupra',
    'Ibiza TDI',
    'Leon',
    'Leon Cupra',
    'Leon e-Hybrid',
    'Leon ST',
    'Leon TDI',
    'Leon VZ',
    'Leon X-Perience',
    'Tavascan',
    'Other',
  ],
  'Dacia': [
    'Duster',
    'Duster 4x4',
    'Duster Adventure',
    'Duster Black Edition',
    'Duster Classic',
    'Duster Hybrid',
    'Duster Outdoor',
    'Duster Prestige',
    'Duster Stepway',
    'Dokker',
    'Dokker Stepway',
    'Dokker Van',
    'Logan',
    'Logan Coupe',
    'Logan Estate',
    'Logan Facelift',
    'Logan MCV',
    'Logan Pickup',
    'Logan Van',
    'Lodgy',
    'Lodgy Stepway',
    'Lodgy Stepway 4x4',
    'Sandero',
    'Sandero 4x4',
    'Sandero Ambiance',
    'Sandero Comfort',
    'Sandero Extreme',
    'Sandero Expression',
    'Sandero RS',
    'Sandero Stepway',
    'Sandero Techroad',
    'Spring',
    'Spring Electric',
    'Spring SUV',
    'Solenza',
    'Other',
  ],
  'Daewoo': [
    'Kalos',
    'Lacetti',
    'Magnus',
    'Matiz',
    'Tosca',
    'Other',
  ],
  'Daihatsu': [
    'Copen',
    'Materia',
    'Mira',
    'Move',
    'Sirion',
    'Terios',
    'Other',
  ],
  'Datsun': [
    'GO',
    'GO+',
    'mi-Do',
    'on-Do',
    'Other',
  ],
  'Dodge': [
    'Avenger',
    'Caliber',
    'Caravan',
    'Challenger',
    'Challenger SRT',
    'Charger',
    'Charger SRT',
    'Dakota',
    'Dakota Sport',
    'Dart',
    'Dodge Demon',
    'Dodge Hornet',
    'Dodge Hornet EV',
    'Dodge Intrepid',
    'Dodge Ram Van',
    'Dodge Stealth',
    'Dodge Stratus',
    'Durango',
    'Durango SRT',
    'Grand Caravan',
    'Journey',
    'Magnum',
    'Neon',
    'Nitro',
    'Ram 1500',
    'Ram 2500',
    'Ram 3500',
    'Ram ProMaster',
    'Ram ProMaster City',
    'Ram Rebel',
    'Ram TRX',
    'SRT4',
    'SRT8',
    'Viper',
    'Other',
  ],
  'DS Automobiles': [
    'DS',
    'DS 3',
    'DS 3 Cabrio',
    'DS 3 Crossback',
    'DS 3 Dark Chrome',
    'DS 3 Dark Side',
    'DS 3 Performance',
    'DS 3 Performance Line',
    'DS 4',
    'DS 4 Crossback',
    'DS 4 Performance Line',
    'DS 4 Plug-in Hybrid',
    'DS 5',
    'DS 5 Hybrid4',
    'DS 5 Performance Line',
    'DS 7 Crossback',
    'DS 7 Crossback Bastille',
    'DS 7 Crossback Connected Chic',
    'DS 7 Crossback E-Tense',
    'DS 7 Crossback Performance Line',
    'DS 7 Crossback PureTech',
    'DS 7 Crossback Rivoli',
    'DS 7 Crossback Ultra Prestige',
    'DS 9',
    'DS 9 BlueHDI',
    'DS 9 Crossback',
    'DS 9 Executive Edition',
    'DS 9 Performance Line',
    'DS 9 Performance Line+',
    'DS Automobiles 7 Crossback',
    'DS E-Tense',
    'DS E-Tense 19',
    'DS E-Tense Performance Line',
    'DS Wild Rubis',
    'DS X E-Tense',
    'Other',
  ],
  'DFM': [
    'A9',
    'AX7',
    'C32',
    'CM7',
    'D01',
    'D02',
    'E11K',
    'E30',
    'E70',
    'F22',
    'F30',
    'Fengon 500',
    'Fengon 500',
    'Fengon 580',
    'Fengon iX5',
    'Fengon iX7',
    'Fengon Mini',
    'Fengon S560',
    'H30 Cross',
    'Jingyi S50',
    'L60',
    'M5',
    'NX',
    'Rich 6',
    'S30',
    'S50',
    'SX6',
    'T5',
    'T7',
    'Yixuan',
    'Other',
  ],
  'Ferrari': [
    '458 Italia',
    '488 GTB',
    '812 Superfast',
    'California',
    'F8 Tributo',
    'GTC4Lusso',
    'LaFerrari',
    'Portofino',
    'Roma',
    'SF90 Stradale',
    'Other',
  ],
  'Fiat': [
    '124 Spider',
    '125',
    '126',
    '127',
    '131',
    '500',
    '500C',
    '500E',
    '500L',
    '500L Lounge',
    '500L Trekking',
    '500X',
    '500X Cross',
    '500X Sport',
    '500X Urban',
    '600',
    'Barchetta',
    'Brava',
    'Bravo',
    'Cinquecento',
    'Coupe',
    'Croma',
    'Dino',
    'Doblo',
    'Doblo Cargo',
    'Doblo Trekking',
    'Ducato',
    'Fiorino',
    'Fiorino Combi',
    'Freemont',
    'Grande Punto',
    'Idea',
    'Linea',
    'Marea',
    'Multipla',
    'Panda',
    'Panda 4x4',
    'Panda Cross',
    'Panda Electric',
    'Panda TwinAir',
    'Punto',
    'Punto Abarth',
    'Punto Evo',
    'Qubo',
    'Tipo',
    'Tipo 5 Door',
    'Tipo Station Wagon',
    'Other',
  ],
  'Ford': [
    'Bronco',
    'EcoSport',
    'Escape',
    'Explorer',
    'F-150',
    'Fiesta',
    'Focus',
    'Fusion',
    'Mustang',
    'Ranger',
    'Taurus',
    'Transit',
    'Other',
  ],
  'Genesis': [
    'G70',
    'G80',
    'G90',
    'GV70',
    'GV80',
    'Other',
  ],
  'GMC': [
    'Acadia',
    'Canyon',
    'Hummer EV',
    'Sierra',
    'Terrain',
    'Yukon',
    'Other',
  ],
  'Honda': [
    'Accord',
    'Clarity',
    'Civic',
    'CR-V',
    'Fit',
    'HR-V',
    'Insight',
    'Odyssey',
    'Passport',
    'Pilot',
    'Other',
  ],
  'Hyundai': [
    'Accent',
    'Atos',
    'Azera',
    'Bayon',
    'Canyon',
    'Coupe',
    'Creta',
    'Elantra',
    'Elantra GT',
    'Elantra N',
    'Elantra Plug-in Hybrid',
    'Elantra Sedan',
    'Elantra Touring',
    'EON',
    'Equus',
    'Genesis',
    'Getz',
    'Ioniq',
    'i10',
    'i10 Plus',
    'i20',
    'i30',
    'i30CW',
    'i40',
    'i40SW',
    'i45',
    'i50',
    'i55',
    'Kona',
    'Kona Electric',
    'Kona Electric Ultimate',
    'Kona N',
    'KONA N Line',
    'Matrix',
    'New i20',
    'New i30',
    'New Sonata',
    'New Tucson',
    'Nexo',
    'Palisade',
    'Pony',
    'Santa Fe',
    'Santa Fe Hybrid',
    'Santa Fe Sport',
    'Santa Fe XL',
    'Sonata',
    'Sonata Hybrid',
    'Sonata N Line',
    'Sonata Plug-in Hybrid',
    'Sonata Sport',
    'Tiburon',
    'Tucson',
    'Tucson Hybrid',
    'Tucson N Line',
    'Tucson Plug-in Hybrid',
    'Tucson XRT',
    'Veloster',
    'Veloster N',
    'Other',
  ],
  'Infiniti': [
    'EX',
    'FX35',
    'FX37',
    'FX50',
    'G20',
    'G25',
    'G35',
    'G37',
    'I30',
    'I35',
    'J30',
    'JX35',
    'JX60',
    'M',
    'M35',
    'M37',
    'M45',
    'M56',
    'MM35h',
    'Q30',
    'Q50',
    'Q50 Red Sport 400',
    'Q60',
    'Q60 Red Sport 400',
    'Q70',
    'Q70L',
    'QX30',
    'QX50',
    'QX55',
    'QX56',
    'QX56 Limited',
    'QX60',
    'QX60 Hybrid',
    'QX60 Luxe',
    'QX70',
    'QX80',
    'QX80 Signature Edition',
    'Other',
  ],
  'Isuzu': [
    'Ascender',
    'D-Max',
    'MU-X',
    'Trooper',
    'Other',
  ],
  'Jaguar': [
    'E-Pace',
    'E-Type',
    'F-Pace',
    'F-Pace SVR',
    'F-Type',
    'F-Type 400 Sport',
    'F-Type Convertible',
    'F-Type Coupe',
    'F-Type R',
    'F-Type R-Dynamic',
    'F-Type SVR',
    'I-Pace',
    'I-Pace EV400',
    'XE',
    'XE R-Dynamic',
    'XF',
    'XF R-Dynamic',
    'XF Sportbrake',
    'XJ',
    'XJ L',
    'XJ220',
    'XJL',
    'XJS',
    'XK',
    'XK8',
    'XKR',
    'XKR-R',
    'XKR-S',
    'XKR-S GT',
    'X-Type',
    'X-Type Estate',
    'Other',
  ],
  'Jeep': [
    'Avenger',
    'Cherokee',
    'Cherokee KL',
    'Commander',
    'Commander (2022)',
    'Commander XK',
    'Compass',
    'Compass MK',
    'Gladiator',
    'Gladiator JT',
    'Grand Cherokee',
    'Grand Cherokee WK',
    'Grand Cherokee WK2',
    'Grand Cherokee WL',
    'Grand Wagoneer',
    'Grand Wagoneer WS',
    'Liberty',
    'Liberty KJ',
    'Liberty KK',
    'Patriot',
    'Patriot MK',
    'Renegade',
    'Renegade BU',
    'Wagoneer',
    'Wagoneer WS',
    'Wrangler',
    'Wrangler JK',
    'Wrangler JL',
    'Wrangler Unlimited',
    'Other',
  ],
  'Kia': [
    'Carnival',
    'Ceed',
    'Ceed GT',
    'Cerato',
    'Cerato Koup',
    'Cutback',
    'Forte',
    'Forte GT',
    'Forte Sedan',
    'K5',
    'K2500',
    'K2700',
    'Magentis',
    'Mohave',
    'Niro',
    'Niro EV',
    'Niro Hybrid',
    'Opirus',
    'Optima',
    'Optima Hybrid',
    'Picanto',
    'Proceed',
    'Rio',
    'Rondo',
    'Sephia',
    'Shuma',
    'Seltos',
    'Sorento',
    'Sorento Hybrid',
    'Soul',
    'Soul EV',
    'Soul GT',
    'Sportage',
    'Sportage Hybrid',
    'Stinger',
    'Stinger GT',
    'Stinger GT2',
    'Stonic',
    'Stonic GT-Line',
    'Xceed',
    'Other',
  ],
  'Koenigsegg': [
    'Agera',
    'CCX',
    'Gemera',
    'Jesko',
    'Regera',
    'Other',
  ],
  'Lamborghini': [
    'Aventador',
    'Gallardo',
    'Huracán',
    'Murciélago',
    'Revuelto',
    'Sian',
    'Urus',
    'Other',
  ],
  'Lancia': [
    'Delta',
    'Thema',
    'Voyager',
    'Ypsilon',
    'Other',
  ],
  'Land Rover': [
    '109',
    '110',
    '90',
    'Defender',
    'Defender 110',
    'Defender 90',
    'Discovery',
    'Discovery 3',
    'Discovery 4',
    'Discovery 5',
    'Discovery Sport',
    'Freelander',
    'Freelander 2',
    'Freelander 2 Sport',
    'Land Rover',
    'Range Rover',
    'Range Rover Classic',
    'Range Rover Evoque',
    'Range Rover LWB',
    'Range Rover PHEV',
    'Range Rover Sport',
    'Range Rover SVAutobiography',
    'Range Rover Velar',
    'Velar',
    'Other',
  ],
  'Lexus': [
    'ES',
    'GS',
    'IS',
    'LC',
    'LX',
    'LS',
    'NX',
    'RC',
    'RX',
    'UX',
    'LFA',
    'Other',
  ],
  'Lincoln': [
    'Aviator',
    'Continental',
    'Corsair',
    'MKC',
    'MKT',
    'MKZ',
    'Navigator',
    'Nautilus',
    'Other',
  ],
  'Lotus': [
    'Elise',
    'Emira',
    'Evija',
    'Evora',
    'Exige',
    'Other',
  ],
  'Mahindra': [
    'Bolero',
    'Scorpio',
    'Thar',
    'XUV300',
    'XUV500',
    'Other',
  ],
  'Maserati': [
    'Ghibli',
    'GranTurismo',
    'Levante',
    'MC20',
    'Quattroporte',
    'Other',
  ],
  'Mazda': [
    'CX-3',
    'CX-5',
    'CX-9',
    'CX-30',
    'Mazda3',
    'Mazda6',
    'MX-5 Miata',
    'RX-8',
    'Other',
  ],
  'McLaren': [
    '570S',
    '650S',
    '720S',
    'Artura',
    'GT',
    'MP4-12C',
    'P1',
    'Senna',
    'Other',
  ],
  'Mercedes-Benz': [
    'A Class',
    'A 45 AMG',
    'AMG A 45',
    'AMG C 63',
    'AMG C 63 S',
    'AMG E 63 S',
    'AMG GT',
    'AMG GT 4 Door Coupe',
    'AMG GT 63',
    'AMG GT 63 S',
    'AMG GT Black Series',
    'B Class',
    'B 250e',
    'B Class Electric Drive',
    'B Class Sports Tourer',
    'C Class',
    'C Class Cabriolet',
    'C Class Coupe',
    'C Class Estate',
    'C Class Sedan',
    'C Class C 300',
    'CLA',
    'CLA Coupe',
    'CLA Shooting Brake',
    'CLC',
    'CLK',
    'CLS',
    'CLS Coupe',
    'CLS Shooting Brake',
    'E Class',
    'E Class Cabriolet',
    'E Class Coupe',
    'E Class Estate',
    'E Class Sedan',
    'E Class E 350',
    'EQB',
    'EQB 300',
    'EQC',
    'EQC 400',
    'EQE',
    'EQE 350',
    'EQS',
    'EQS 580',
    'EQS SUV',
    'G Class',
    'G Class AMG',
    'G Class Cabriolet',
    'G Class G Wagon',
    'GLA',
    'GLA 250',
    'GLA 45 AMG',
    'GLA Coupe',
    'GLB',
    'GLB Coupe',
    'GLC',
    'GLC 300',
    'GLC 350e',
    'GLC 63',
    'GLC 63 S',
    'GLC Coupe',
    'GLC F Cell',
    'GLE',
    'GLE 63',
    'GLE 63 S',
    'GLE Coupe',
    'GLE Sedan',
    'GLK',
    'GLS',
    'GLS Coupe',
    'GLS Maybach',
    'M Class',
    'M Class Coupe',
    'Maybach 57',
    'Maybach 62',
    'Maybach S Class',
    'Metris',
    'ML',
    'R Class',
    'S Class',
    'S Class Cabriolet',
    'S Class Coupe',
    'S Class Sedan',
    'S Class S 580',
    'S Class S 600',
    'S Class S 650',
    'SLC',
    'SLC Roadster',
    'SL Class',
    'SLK',
    'SL Roadster',
    'SLS AMG',
    'SLS AMG Roadster',
    'Smart EQ',
    'Smart ForFour',
    'Smart ForTwo',
    'Sprinter',
    'V Class',
    'V Class LWB',
    'V Class Marco Polo',
    'V Class RWD',
    'V Class Tourer',
    'Vito',
    'Vito Panel Van',
    'Vito Tourer',
    'Other',
  ],
  'MG (Morris Garages)': [
    'MG3',
    'MG5',
    'MG6',
    'MG HS',
    'MG Marvel R',
    'MG ZS',
    'Other',
  ],
  'Mini': [
    'Clubman',
    'Cooper',
    'Countryman',
    'Coupe',
    'Paceman',
    'Roadster',
    'Other',
  ],
  'Mitsubishi': [
    '3000GT',
    'ASX',
    'Colt',
    'Eclipse',
    'Eclipse Cross',
    'Galant',
    'Galant Fortis',
    'Grandis',
    'i-MiEV',
    'L200',
    'Lancer',
    'Lancer Evolution',
    'Lancer Evolution X',
    'Mirage',
    'Montero',
    'Montero Sport',
    'Outlander',
    'Outlander PHEV',
    'Outlander Sport',
    'Pajero',
    'Pajero Sport',
    'RVR',
    'Shogun',
    'Space Star',
    'Other',
  ],
  'Nissan': [
    '350Z',
    '370Z',
    '370Z Roadster',
    'Altima',
    'Altima Hybrid',
    'Almera',
    'Armada',
    'Bluebird',
    'Cabstar',
    'Cherry',
    'Civilian',
    'Cube',
    'Frontier',
    'Frontier Pro-4X',
    'GT-R',
    'GT-R Nismo',
    'Juke',
    'Juke Nismo',
    'Leaf',
    'Leaf Plus',
    'Maxima',
    'Micra',
    'Murano',
    'Murano Hybrid',
    'Navara',
    'NV1500',
    'NV200',
    'NV2500',
    'NV3500',
    'Pathfinder',
    'Pathfinder Hybrid',
    'Patrol',
    'Pickup',
    'Pixo',
    'Primera',
    'Qashqai',
    'Qashqai Nismo',
    'Quest',
    'Rogue',
    'Rogue Hybrid',
    'Rogue Sport',
    'Sentra',
    'Serena',
    'Skyline',
    'Sunny',
    'Terrano',
    'Titan',
    'Titan XD',
    'Versa',
    'Versa Note',
    'X-Trail',
    'Xterra',
    'Other',
  ],
  'Opel': [
    'Adam',
    'Agila',
    'Ampera',
    'Ampera-e',
    'Antara',
    'Astra',
    'Cascada',
    'Combo',
    'Corsa',
    'Crossland X',
    'Grandland X',
    'Insignia',
    'Karl',
    'Meriva',
    'Mokka',
    'Movano',
    'Signum',
    'Speedster',
    'Tigra',
    'Vectra',
    'Vivaro',
    'Zafira',
    'other',
  ],
  'Pagani': [
    'Huayra',
    'Utopia',
    'Zonda',
    'Other',
  ],
  'Peugeot': [
    '1007',
    '108',
    '2008',
    '2008 GT',
    '2008 GT Line',
    '206',
    '207',
    '208',
    '208 Allure',
    '208 CC',
    '208 Electric',
    '208 GT',
    '208 GT Line',
    '208 GTi',
    '301',
    '306',
    '307',
    '308',
    '308 CC',
    '309',
    '3008',
    '3008 Allure',
    '3008 Crossway',
    '3008 GT',
    '3008 GT Line',
    '3008 Hybrid',
    '3008 Hybrid4',
    '3008 PHEV',
    '3008 SW',
    '4007',
    '4008',
    '407',
    '407 SW',
    '408',
    '408 PHEV',
    '5008',
    '5008 GT',
    '5008 GT Line',
    '5008 Hybrid',
    '5008 Hybrid4',
    '5008 PHEV',
    '508',
    '508 GT',
    '508 GT Line',
    '508 Hybrid',
    '508 Hybrid4',
    '508 RXH',
    '508 SW',
    'Bipper',
    'Boxer',
    'Expert',
    'Expert Tepee',
    'Landtrek',
    'Partner',
    'Partner Tepee',
    'RCZ',
    'Rifter',
    'Traveller',
    'Other',
  ],
  'Polestar': [
    'Polestar 1',
    'Polestar 2',
    'Polestar 3',
    'Other',
  ],
  'Porsche': [
    '911',
    '911 Cabriolet',
    '911 Sport Classic',
    '918 Spyder',
    '944',
    '968',
    'Boxster',
    'Boxster Spyder',
    'Carrera GT',
    'Cayenne',
    'Cayman',
    'Macan',
    'Panamera',
    'Taycan',
    'Other',
  ],
  'Ram': [
    '1500',
    '2500',
    '3500',
    'ProMaster',
    'ProMaster City',
    'Other',
  ],
  'Renault': [
    'Alaskan',
    'Arkana',
    'Captur',
    'Clio 1',
    'Clio 2',
    'Clio 3',
    'Clio 4',
    'Clio 4 RS',
    'Clio 5',
    'Clio Campus',
    'Clio Classique',
    'Colorale',
    'Duster',
    'Espace',
    'Fluence',
    'Floride',
    'Grand Scénic',
    'Kadjar',
    'Kangoo',
    'Koleos',
    'Kwid',
    'Laguna',
    'Latitude',
    'Lodgy',
    'Logan',
    'Master',
    'Mégane',
    'Modus',
    'Safrane',
    'Sandero',
    'Scénic',
    'Symbol',
    'Talisman',
    'Trafic',
    'Triber',
    'Twingo',
    'Vel Satis',
    'Wind',
    'Zoe',
    'Other',
  ],
  'Rolls-Royce': [
    'Cullinan',
    'Dawn',
    'Ghost',
    'Phantom',
    'Spectre',
    'Wraith',
    'Other',
  ],
  'Saab': [
    '9-3',
    '9-4X',
    '9-5',
    '9-7X',
    'Other',
  ],
  'Seat': [
    'Alhambra',
    'Altea',
    'Arona',
    'Arosa',
    'Ateca',
    'Born',
    'Córdoba',
    'Exeo',
    'Freetrack',
    'Ibiza',
    'Leon',
    'Malaga',
    'Marbella',
    'Mii',
    'Tarraco',
    'Toledo',
    'Other',
  ],
  'Skoda': [
    'Citigo',
    'Enyaq',
    'Fabia',
    'Favorite',
    'Felicia',
    'Kamiq',
    'Karoq',
    'Kodiaq',
    'Octavia',
    'Praktik',
    'Rapid',
    'Roomster',
    'Scala',
    'Superb',
    'Yeti',
    'Other',
  ],
  'Smart': [
    'Fortwo',
    'Forfour',
    'Roadster',
    'Other',
  ],
  'SsangYong': [
    'Korando',
    'Musso',
    'Rexton',
    'Rodius',
    'Tivoli',
    'XLV',
    'Other',
  ],
  'Subaru': [
    'Ascent',
    'BRZ',
    'Crosstrek',
    'Forester',
    'Impreza',
    'Legacy',
    'Outback',
    'WRX',
    'XV',
    'Other',
  ],
  'Suzuki': [
    'Across',
    'Alto',
    'Baleno',
    'Celerio',
    'Ciaz',
    'Ertiga',
    'Grand Vitara',
    'Ignis',
    'Jimny',
    'Kizashi',
    'Liana',
    'Maruti',
    'Samurai',
    'Splash',
    'SX4',
    'Swift',
    'Vitara',
    'Wagon R',
    'X90',
    'Other',
  ],
  'Tata Motors': [
    'Altroz',
    'Aria',
    'Harrier',
    'Hexa',
    'Nexon',
    'Punch',
    'Safari',
    'Tiago',
    'Tigor',
    'Other',
  ],
  'Tesla': [
    'Cybertruck',
    'Model 3',
    'Model S',
    'Model X',
    'Model Y',
    'Roadster',
    'Semi',
    'other',
  ],
  'Toyota': [
    '4Runner',
    '86',
    'Agya',
    'Alphard',
    'Auris',
    'Avalon',
    'Avenza',
    'Avensis',
    'Aygo',
    'bZ4X',
    'C-HR',
    'Camry',
    'Carina',
    'Celia',
    'Corolla',
    'Corolla GT',
    'Corolla Verso',
    'Crown',
    'Echo',
    'Etios',
    'FJ Cruiser',
    'Fortuner',
    'Fortune',
    'GR Supra',
    'GR Yaris',
    'GR86',
    'GT 86',
    'Highlander',
    'Hilux',
    'Innova',
    'Ist',
    'iQ',
    'Land Cruiser',
    'MR',
    'Mark X',
    'Matrix',
    'Mirai',
    'New Corolla',
    'Passo',
    'Previa',
    'Prius',
    'Prius',
    'Prado',
    'Proace',
    'Proace City',
    'RAV4',
    'Rush',
    'Runner',
    'Scion FR-S (as Toyota)',
    'Scion iA (as Toyota)',
    'Scion iM (as Toyota)',
    'Scion tC (as Toyota)',
    'Scion xB (as Toyota)',
    'Sequoia',
    'Sienna',
    'Sienta',
    'Starlet',
    'Supra',
    'Tacoma',
    'Tundra',
    'Urban Cruiser',
    'Urban Cruiser',
    'Vellfire',
    'Venza',
    'Vios',
    'Yaris',
    'other',
  ],
  'Vauxhall': [
    'Adam',
    'Astra',
    'Corsa',
    'Crossland',
    'Grandland',
    'Insignia',
    'Mokka',
    'Viva',
    'Zafira',
    'other',
  ],
  'Volvo': [
    'C30',
    'C40',
    'S60',
    'S90',
    'V40',
    'V60',
    'V70',
    'V90',
    'XC40',
    'XC60',
    'XC90',
    'other',
  ],
  'Wiesmann': [
    'GT MF5',
    'Roadster MF4',
    'other',
  ],
  'Chery': [
    'A1',
    'A3',
    'A5',
    'Arrizo',
    'Bonus',
    'Cowin',
    'E5',
    'Fora',
    'Fulwin',
    'Karry',
    'QQ',
    'Rely',
    'Riich',
    'Tiggo',
    'X1',
    'X5',
    'Other',
  ],
  'Geely': [
    'Atlas',
    'Azkarra',
    'Binrui',
    'Binyue',
    'Borui',
    'Boyue',
    'CK',
    'Coolray',
    'Emgrand',
    'FY11',
    'GC9',
    'Geometry A',
    'Geometry C',
    'GS',
    'GX3 Pro',
    'GX7',
    'Haoyue',
    'Haoqing',
    'Icon',
    'Jiaji',
    'MK',
    'Monjaro',
    'Okavango',
    'Panda',
    'Preface',
    'Ray',
    'S5',
    'Starray',
    'SX11',
    'Tugella',
    'Vision',
    'Xingyue',
    'Yuanjing',
    'Other',
  ],
  'Greatwall': [
    'C30',
    'Florid',
    'H2',
    'H3',
    'H5',
    'H6',
    'H6 Coupe',
    'H9',
    'Hover',
    'M4',
    'M6',
    'New Florid',
    'ORA Black Cat',
    'ORA Funky Cat',
    'ORA Good Cat',
    'Pao',
    'Peri',
    'Poer',
    'P-Series',
    'Steed',
    'voleex c30',
    'Wingle',
    'Wingle 5',
    'Wingle 6',
    'Wingle 7',
    'X240',
    'other',
  ],
  'Haval': [
    'H6',
    'H9',
    'Jolion',
    'Big Dog',
    'M6',
    'Other',
  ],
  'JAC Motors': [
    'iEV7S',
    'iEV6E',
    'T8',
    'S4',
    'Other',
  ],
  'GAC Motors': [
    'GA3',
    'GA4',
    'GA5',
    'GA6',
    'GA8',
    'GN8',
    'GS3',
    'GS4',
    'GS5',
    'GS7',
    'GS8',
    'GN8',
    'Trumpchi',
    'Aion S',
    'Aion LX',
    'Aion V',
    'Aion Y',
    'Other',
  ],
  'MG Motor': [
    'MG3',
    'MG5',
    'MG6',
    'MG ZS',
    'MG HS',
    'MG Marvel R',
    'Other',
  ],
  'NIO': [
    'ES6',
    'ES8',
    'EC6',
    'ET7',
    'ET5',
    'Other',
  ],
  'Volkswagen': [
    'Amarok',
    'Arteon',
    'Atlas',
    'Atlas Cross Sport',
    'Beetle',
    'Beetle Cabriolet',
    'Beetle Convertible',
    'Bora',
    'Caddy',
    'Caddy Life',
    'Caddy Maxi',
    'California',
    'Caravelle',
    'CC',
    'Coccinelle',
    'Crafter',
    'Crrado',
    'CrossFox',
    'CrossGolf',
    'CrossPolo',
    'CrossTouran',
    'Derby',
    'Eos',
    'Fox',
    'Golf 1',
    'Golf 2',
    'Golf 3',
    'Golf 4',
    'Golf 5',
    'Golf 6',
    'Golf 7',
    'Golf 8',
    'Golf Alltrack',
    'Golf Cabriolet',
    'Golf GTI',
    'Golf Plus',
    'Golf R',
    'Golf Sportsvan',
    'Golf SV',
    'Golf Variant',
    'ID.3',
    'ID.4',
    'ID.5',
    'Jetta',
    'Jetta Hybrid',
    'K70',
    'Karmann',
    'Lavida',
    'Lupo',
    'Multivan',
    'New Beetle',
    'Passat',
    'Passat Alltrack',
    'Passat CC',
    'Passat Variant',
    'Phideon',
    'Polo',
    'Polo 3',
    'Polo GTI',
    'Polo Sedan',
    'Polo Vivo',
    'Scirocco',
    'Sharan',
    'T-Cross',
    'T-Roc',
    'Tayron',
    'Tiguan',
    'Touran',
    'Transporter',
    'Up',
    'Vento',
    'other',
  ],
  'Wuling': [
    'Hongguang Mini EV',
    'Almaz',
    'Confero',
    'Cortez',
  ],
  'Zotye': [
    '2008',
    '3008',
    'Cargo',
    'Cloud 100',
    'Cloud 200',
    'Cloud 300',
    'E200',
    'E300',
    'Hunter',
    'M 300',
    'Nomad',
    'T300',
    'T500',
    'Z100',
    'Z200',
    'Z300',
    'Other',
  ],
  'Baojun': [
    '310',
    '510',
    '530',
    'E100',
    'E200',
    'Other',
  ],
  'Brilliance': [
    'H530',
    'V5',
    'V7',
    'Other',
  ],
  'Changan': [
    'CS75',
    'CS55',
    'Eado',
    'UNI-K',
    'UNI-T',
    'Other',
  ],
  'Dongfeng': [
    'AX7',
    'S30',
    'H30',
    'A9',
    'Other',
  ],
  'FAW': [
    'Besturn B50',
    'Besturn X80',
    'Hongqi H5',
    'Hongqi H7',
    'Other',
  ]
};
