import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

// ============================================================
// ENUMS MÉTIER (calqués sur les choix de l'API Dev Couturier)
// ============================================================

/// Statuts de commande. `enAttente` couvre draft + confirmed côté API.
enum StatutCommande { enAttente, enCours, terminee, livree, annulee }

/// Modes de paiement de l'API : cash, orange_money, moov_money,
/// bank_transfer, card, other.
enum ModePaiement { especes, orangeMoney, moovMoney, virement, carte, autre }

/// Valeurs du champ `Paiements.statut`. Un paiement annulé côté API est
/// supprimé localement (`deletedAt`).
abstract final class StatutPaiement {
  static const enAttente = 'en_attente';
  static const reussi = 'reussi';
  static const echoue = 'echoue';
}

/// Rôles d'un membre dans l'atelier (WorkshopMembership.Role).
enum RoleMembre { owner, manager, tailor, member }

// ============================================================
// COLONNES COMMUNES
// ============================================================

final uuidGenerator = Uuid();

mixin SyncColumns on Table {
  TextColumn get id => text().clientDefault(() => uuidGenerator.v4())();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

// ============================================================
// ATELIER (Workshop)
// ============================================================

class Salons extends Table with SyncColumns {
  TextColumn get nom => text().withLength(min: 1, max: 200)();
  TextColumn get email => text().nullable()();
  TextColumn get telephone => text().withLength(max: 30).nullable()();
  TextColumn get adresse => text().nullable()();
  TextColumn get devise => text().withDefault(const Constant('FCFA'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// MEMBRES DE L'ATELIER (WorkshopMembership, lus depuis l'API)
// ============================================================

class Users extends Table with SyncColumns {
  TextColumn get username => text().withLength(min: 1, max: 150)();
  TextColumn get email => text().nullable()();
  TextColumn get firstName => text().withLength(max: 150).nullable()();
  TextColumn get lastName => text().withLength(max: 150).nullable()();
  TextColumn get telephone => text().withLength(max: 30).nullable()();
  TextColumn get role => textEnum<RoleMembre>().withDefault(const Constant('member'))();
  BoolColumn get estActif => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// CLIENTS (Client)
// ============================================================

class Clients extends Table with SyncColumns {
  /// `last_name` côté API (ou le nom complet si le client n'a qu'un nom).
  TextColumn get nom => text().withLength(min: 1, max: 100)();
  TextColumn get prenom => text().withLength(max: 100).nullable()();
  /// Obligatoire côté API.
  TextColumn get telephone => text().withLength(max: 30).nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get adresse => text().nullable()();
  TextColumn get note => text().nullable()();
  /// UUID de la ressource côté API (null tant qu'elle n'a pas été envoyée).
  TextColumn get remoteId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// RELEVÉS DE MESURES (MeasurementRecord)
// Une fiche + ses mesures = un relevé ; `libelle` part dans `notes`.
// ============================================================

class FichesMesures extends Table with SyncColumns {
  TextColumn get clientId =>
      text().references(Clients, #id, onDelete: KeyAction.cascade)();
  TextColumn get libelle => text().withLength(min: 1, max: 100)();
  /// UUID de la ressource côté API (null tant qu'elle n'a pas été envoyée).
  TextColumn get remoteId => text().nullable()();
  DateTimeColumn get datePrise => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Mesures extends Table with SyncColumns {
  TextColumn get ficheId =>
      text().references(FichesMesures, #id, onDelete: KeyAction.cascade)();
  TextColumn get nomMesure => text().withLength(min: 1, max: 100)();
  RealColumn get valeur => real()();
  TextColumn get unite => text().withDefault(const Constant('cm'))();
  IntColumn get ordre => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// CATALOGUE (CatalogModel)
// ============================================================

class Modeles extends Table with SyncColumns {
  TextColumn get nom => text().withLength(min: 1, max: 150)();
  TextColumn get description => text().nullable()();
  /// `base_price` côté API.
  IntColumn get prixIndicatif => integer().nullable()();
  /// `category` côté API (Homme, Femme, Enfant…).
  TextColumn get typeVetement => text().nullable()();
  /// `image_url` côté API : photo hébergée, affichée en lecture seule.
  TextColumn get imageUrl => text().nullable()();
  /// `is_published` côté API : visible dans le catalogue client.
  BoolColumn get estPublie => boolean().withDefault(const Constant(false))();
  /// UUID de la ressource côté API (null tant qu'elle n'a pas été envoyée).
  TextColumn get remoteId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// COMMANDES (Order + un article)
// ============================================================

class Commandes extends Table with SyncColumns {
  TextColumn get clientId =>
      text().references(Clients, #id, onDelete: KeyAction.restrict)();
  /// `catalog_model` côté API.
  TextColumn get modeleId =>
      text().references(Modeles, #id, onDelete: KeyAction.setNull).nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get notes => text().nullable()();
  /// Prix de l'article unique de la commande (`items[0].unit_price`).
  IntColumn get prixConvenu => integer()();
  DateTimeColumn get dateCommande =>
      dateTime().withDefault(currentDateAndTime)();
  /// `due_date` côté API.
  DateTimeColumn get dateEcheance => dateTime()();
  TextColumn get statut =>
      textEnum<StatutCommande>().withDefault(const Constant('enAttente'))();
  /// UUID de la ressource côté API (null tant qu'elle n'a pas été envoyée).
  TextColumn get remoteId => text().nullable()();
  /// Statut côté API (draft, confirmed, in_progress, ready, delivered, cancelled).
  TextColumn get statutDistant => text().nullable()();
  /// Référence attribuée par le serveur (ex. CMD-2026-0042).
  TextColumn get reference => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// PAIEMENTS (Payment)
// ============================================================

class Paiements extends Table with SyncColumns {
  TextColumn get commandeId =>
      text().references(Commandes, #id, onDelete: KeyAction.cascade)();
  IntColumn get montant => integer()();
  DateTimeColumn get datePaiement =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get mode =>
      textEnum<ModePaiement>().withDefault(const Constant('especes'))();
  TextColumn get note => text().nullable()();
  /// Seuls les paiements `reussi` comptent dans les encaissements.
  TextColumn get statut =>
      text().withDefault(const Constant(StatutPaiement.reussi))();
  /// `transaction_reference` côté API (référence du SMS Mobile Money…).
  TextColumn get reference => text().nullable()();
  /// UUID de la ressource côté API (null tant qu'elle n'a pas été envoyée).
  TextColumn get remoteId => text().nullable()();
  /// Statut côté API (pending, confirmed, failed, cancelled, refunded).
  TextColumn get statutDistant => text().nullable()();
  /// Numéro de reçu attribué à la confirmation (ex. REC-2026-00042).
  TextColumn get numeroRecu => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
