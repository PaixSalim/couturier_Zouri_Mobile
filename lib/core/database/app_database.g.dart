// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SalonsTable extends Salons with TableInfo<$SalonsTable, Salon> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => uuidGenerator.v4());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _telephoneMeta =
      const VerificationMeta('telephone');
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
      'telephone', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _adresseMeta =
      const VerificationMeta('adresse');
  @override
  late final GeneratedColumn<String> adresse = GeneratedColumn<String>(
      'adresse', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deviseMeta = const VerificationMeta('devise');
  @override
  late final GeneratedColumn<String> devise = GeneratedColumn<String>(
      'devise', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('FCFA'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        deletedAt,
        isSynced,
        nom,
        email,
        telephone,
        adresse,
        devise
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'salons';
  @override
  VerificationContext validateIntegrity(Insertable<Salon> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('telephone')) {
      context.handle(_telephoneMeta,
          telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta));
    }
    if (data.containsKey('adresse')) {
      context.handle(_adresseMeta,
          adresse.isAcceptableOrUnknown(data['adresse']!, _adresseMeta));
    }
    if (data.containsKey('devise')) {
      context.handle(_deviseMeta,
          devise.isAcceptableOrUnknown(data['devise']!, _deviseMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Salon map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Salon(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      telephone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telephone']),
      adresse: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}adresse']),
      devise: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}devise'])!,
    );
  }

  @override
  $SalonsTable createAlias(String alias) {
    return $SalonsTable(attachedDatabase, alias);
  }
}

class Salon extends DataClass implements Insertable<Salon> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isSynced;
  final String nom;
  final String? email;
  final String? telephone;
  final String? adresse;
  final String devise;
  const Salon(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.isSynced,
      required this.nom,
      this.email,
      this.telephone,
      this.adresse,
      required this.devise});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['nom'] = Variable<String>(nom);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || telephone != null) {
      map['telephone'] = Variable<String>(telephone);
    }
    if (!nullToAbsent || adresse != null) {
      map['adresse'] = Variable<String>(adresse);
    }
    map['devise'] = Variable<String>(devise);
    return map;
  }

  SalonsCompanion toCompanion(bool nullToAbsent) {
    return SalonsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isSynced: Value(isSynced),
      nom: Value(nom),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      telephone: telephone == null && nullToAbsent
          ? const Value.absent()
          : Value(telephone),
      adresse: adresse == null && nullToAbsent
          ? const Value.absent()
          : Value(adresse),
      devise: Value(devise),
    );
  }

  factory Salon.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Salon(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      nom: serializer.fromJson<String>(json['nom']),
      email: serializer.fromJson<String?>(json['email']),
      telephone: serializer.fromJson<String?>(json['telephone']),
      adresse: serializer.fromJson<String?>(json['adresse']),
      devise: serializer.fromJson<String>(json['devise']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'nom': serializer.toJson<String>(nom),
      'email': serializer.toJson<String?>(email),
      'telephone': serializer.toJson<String?>(telephone),
      'adresse': serializer.toJson<String?>(adresse),
      'devise': serializer.toJson<String>(devise),
    };
  }

  Salon copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          bool? isSynced,
          String? nom,
          Value<String?> email = const Value.absent(),
          Value<String?> telephone = const Value.absent(),
          Value<String?> adresse = const Value.absent(),
          String? devise}) =>
      Salon(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        isSynced: isSynced ?? this.isSynced,
        nom: nom ?? this.nom,
        email: email.present ? email.value : this.email,
        telephone: telephone.present ? telephone.value : this.telephone,
        adresse: adresse.present ? adresse.value : this.adresse,
        devise: devise ?? this.devise,
      );
  Salon copyWithCompanion(SalonsCompanion data) {
    return Salon(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      nom: data.nom.present ? data.nom.value : this.nom,
      email: data.email.present ? data.email.value : this.email,
      telephone: data.telephone.present ? data.telephone.value : this.telephone,
      adresse: data.adresse.present ? data.adresse.value : this.adresse,
      devise: data.devise.present ? data.devise.value : this.devise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Salon(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('nom: $nom, ')
          ..write('email: $email, ')
          ..write('telephone: $telephone, ')
          ..write('adresse: $adresse, ')
          ..write('devise: $devise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, deletedAt, isSynced,
      nom, email, telephone, adresse, devise);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Salon &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isSynced == this.isSynced &&
          other.nom == this.nom &&
          other.email == this.email &&
          other.telephone == this.telephone &&
          other.adresse == this.adresse &&
          other.devise == this.devise);
}

class SalonsCompanion extends UpdateCompanion<Salon> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> isSynced;
  final Value<String> nom;
  final Value<String?> email;
  final Value<String?> telephone;
  final Value<String?> adresse;
  final Value<String> devise;
  final Value<int> rowid;
  const SalonsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.nom = const Value.absent(),
    this.email = const Value.absent(),
    this.telephone = const Value.absent(),
    this.adresse = const Value.absent(),
    this.devise = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalonsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    required String nom,
    this.email = const Value.absent(),
    this.telephone = const Value.absent(),
    this.adresse = const Value.absent(),
    this.devise = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : nom = Value(nom);
  static Insertable<Salon> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? isSynced,
    Expression<String>? nom,
    Expression<String>? email,
    Expression<String>? telephone,
    Expression<String>? adresse,
    Expression<String>? devise,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (nom != null) 'nom': nom,
      if (email != null) 'email': email,
      if (telephone != null) 'telephone': telephone,
      if (adresse != null) 'adresse': adresse,
      if (devise != null) 'devise': devise,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalonsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<bool>? isSynced,
      Value<String>? nom,
      Value<String?>? email,
      Value<String?>? telephone,
      Value<String?>? adresse,
      Value<String>? devise,
      Value<int>? rowid}) {
    return SalonsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      adresse: adresse ?? this.adresse,
      devise: devise ?? this.devise,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (adresse.present) {
      map['adresse'] = Variable<String>(adresse.value);
    }
    if (devise.present) {
      map['devise'] = Variable<String>(devise.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalonsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('nom: $nom, ')
          ..write('email: $email, ')
          ..write('telephone: $telephone, ')
          ..write('adresse: $adresse, ')
          ..write('devise: $devise, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => uuidGenerator.v4());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _telephoneMeta =
      const VerificationMeta('telephone');
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
      'telephone', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<RoleMembre, String> role =
      GeneratedColumn<String>('role', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('member'))
          .withConverter<RoleMembre>($UsersTable.$converterrole);
  static const VerificationMeta _estActifMeta =
      const VerificationMeta('estActif');
  @override
  late final GeneratedColumn<bool> estActif = GeneratedColumn<bool>(
      'est_actif', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("est_actif" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        deletedAt,
        isSynced,
        username,
        email,
        firstName,
        lastName,
        telephone,
        role,
        estActif
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    }
    if (data.containsKey('telephone')) {
      context.handle(_telephoneMeta,
          telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta));
    }
    if (data.containsKey('est_actif')) {
      context.handle(_estActifMeta,
          estActif.isAcceptableOrUnknown(data['est_actif']!, _estActifMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name']),
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name']),
      telephone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telephone']),
      role: $UsersTable.$converterrole.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!),
      estActif: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}est_actif'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RoleMembre, String, String> $converterrole =
      const EnumNameConverter<RoleMembre>(RoleMembre.values);
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isSynced;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? telephone;
  final RoleMembre role;
  final bool estActif;
  const User(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.isSynced,
      required this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.telephone,
      required this.role,
      required this.estActif});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || telephone != null) {
      map['telephone'] = Variable<String>(telephone);
    }
    {
      map['role'] = Variable<String>($UsersTable.$converterrole.toSql(role));
    }
    map['est_actif'] = Variable<bool>(estActif);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isSynced: Value(isSynced),
      username: Value(username),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      telephone: telephone == null && nullToAbsent
          ? const Value.absent()
          : Value(telephone),
      role: Value(role),
      estActif: Value(estActif),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String?>(json['email']),
      firstName: serializer.fromJson<String?>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      telephone: serializer.fromJson<String?>(json['telephone']),
      role: $UsersTable.$converterrole
          .fromJson(serializer.fromJson<String>(json['role'])),
      estActif: serializer.fromJson<bool>(json['estActif']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String?>(email),
      'firstName': serializer.toJson<String?>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'telephone': serializer.toJson<String?>(telephone),
      'role':
          serializer.toJson<String>($UsersTable.$converterrole.toJson(role)),
      'estActif': serializer.toJson<bool>(estActif),
    };
  }

  User copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          bool? isSynced,
          String? username,
          Value<String?> email = const Value.absent(),
          Value<String?> firstName = const Value.absent(),
          Value<String?> lastName = const Value.absent(),
          Value<String?> telephone = const Value.absent(),
          RoleMembre? role,
          bool? estActif}) =>
      User(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        isSynced: isSynced ?? this.isSynced,
        username: username ?? this.username,
        email: email.present ? email.value : this.email,
        firstName: firstName.present ? firstName.value : this.firstName,
        lastName: lastName.present ? lastName.value : this.lastName,
        telephone: telephone.present ? telephone.value : this.telephone,
        role: role ?? this.role,
        estActif: estActif ?? this.estActif,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      telephone: data.telephone.present ? data.telephone.value : this.telephone,
      role: data.role.present ? data.role.value : this.role,
      estActif: data.estActif.present ? data.estActif.value : this.estActif,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('telephone: $telephone, ')
          ..write('role: $role, ')
          ..write('estActif: $estActif')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, deletedAt, isSynced,
      username, email, firstName, lastName, telephone, role, estActif);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isSynced == this.isSynced &&
          other.username == this.username &&
          other.email == this.email &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.telephone == this.telephone &&
          other.role == this.role &&
          other.estActif == this.estActif);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> isSynced;
  final Value<String> username;
  final Value<String?> email;
  final Value<String?> firstName;
  final Value<String?> lastName;
  final Value<String?> telephone;
  final Value<RoleMembre> role;
  final Value<bool> estActif;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.telephone = const Value.absent(),
    this.role = const Value.absent(),
    this.estActif = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    required String username,
    this.email = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.telephone = const Value.absent(),
    this.role = const Value.absent(),
    this.estActif = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : username = Value(username);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? isSynced,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? telephone,
    Expression<String>? role,
    Expression<bool>? estActif,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (telephone != null) 'telephone': telephone,
      if (role != null) 'role': role,
      if (estActif != null) 'est_actif': estActif,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<bool>? isSynced,
      Value<String>? username,
      Value<String?>? email,
      Value<String?>? firstName,
      Value<String?>? lastName,
      Value<String?>? telephone,
      Value<RoleMembre>? role,
      Value<bool>? estActif,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      telephone: telephone ?? this.telephone,
      role: role ?? this.role,
      estActif: estActif ?? this.estActif,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (role.present) {
      map['role'] =
          Variable<String>($UsersTable.$converterrole.toSql(role.value));
    }
    if (estActif.present) {
      map['est_actif'] = Variable<bool>(estActif.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('telephone: $telephone, ')
          ..write('role: $role, ')
          ..write('estActif: $estActif, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => uuidGenerator.v4());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _prenomMeta = const VerificationMeta('prenom');
  @override
  late final GeneratedColumn<String> prenom = GeneratedColumn<String>(
      'prenom', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _telephoneMeta =
      const VerificationMeta('telephone');
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
      'telephone', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _adresseMeta =
      const VerificationMeta('adresse');
  @override
  late final GeneratedColumn<String> adresse = GeneratedColumn<String>(
      'adresse', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        deletedAt,
        isSynced,
        nom,
        prenom,
        telephone,
        email,
        adresse,
        note,
        remoteId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(Insertable<Client> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('prenom')) {
      context.handle(_prenomMeta,
          prenom.isAcceptableOrUnknown(data['prenom']!, _prenomMeta));
    }
    if (data.containsKey('telephone')) {
      context.handle(_telephoneMeta,
          telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('adresse')) {
      context.handle(_adresseMeta,
          adresse.isAcceptableOrUnknown(data['adresse']!, _adresseMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      prenom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prenom']),
      telephone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telephone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      adresse: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}adresse']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class Client extends DataClass implements Insertable<Client> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isSynced;

  /// `last_name` côté API (ou le nom complet si le client n'a qu'un nom).
  final String nom;
  final String? prenom;

  /// Obligatoire côté API.
  final String? telephone;
  final String? email;
  final String? adresse;
  final String? note;

  /// UUID de la ressource côté API (null tant qu'elle n'a pas été envoyée).
  final String? remoteId;
  const Client(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.isSynced,
      required this.nom,
      this.prenom,
      this.telephone,
      this.email,
      this.adresse,
      this.note,
      this.remoteId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['nom'] = Variable<String>(nom);
    if (!nullToAbsent || prenom != null) {
      map['prenom'] = Variable<String>(prenom);
    }
    if (!nullToAbsent || telephone != null) {
      map['telephone'] = Variable<String>(telephone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || adresse != null) {
      map['adresse'] = Variable<String>(adresse);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isSynced: Value(isSynced),
      nom: Value(nom),
      prenom:
          prenom == null && nullToAbsent ? const Value.absent() : Value(prenom),
      telephone: telephone == null && nullToAbsent
          ? const Value.absent()
          : Value(telephone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      adresse: adresse == null && nullToAbsent
          ? const Value.absent()
          : Value(adresse),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
    );
  }

  factory Client.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      nom: serializer.fromJson<String>(json['nom']),
      prenom: serializer.fromJson<String?>(json['prenom']),
      telephone: serializer.fromJson<String?>(json['telephone']),
      email: serializer.fromJson<String?>(json['email']),
      adresse: serializer.fromJson<String?>(json['adresse']),
      note: serializer.fromJson<String?>(json['note']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'nom': serializer.toJson<String>(nom),
      'prenom': serializer.toJson<String?>(prenom),
      'telephone': serializer.toJson<String?>(telephone),
      'email': serializer.toJson<String?>(email),
      'adresse': serializer.toJson<String?>(adresse),
      'note': serializer.toJson<String?>(note),
      'remoteId': serializer.toJson<String?>(remoteId),
    };
  }

  Client copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          bool? isSynced,
          String? nom,
          Value<String?> prenom = const Value.absent(),
          Value<String?> telephone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> adresse = const Value.absent(),
          Value<String?> note = const Value.absent(),
          Value<String?> remoteId = const Value.absent()}) =>
      Client(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        isSynced: isSynced ?? this.isSynced,
        nom: nom ?? this.nom,
        prenom: prenom.present ? prenom.value : this.prenom,
        telephone: telephone.present ? telephone.value : this.telephone,
        email: email.present ? email.value : this.email,
        adresse: adresse.present ? adresse.value : this.adresse,
        note: note.present ? note.value : this.note,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
      );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      nom: data.nom.present ? data.nom.value : this.nom,
      prenom: data.prenom.present ? data.prenom.value : this.prenom,
      telephone: data.telephone.present ? data.telephone.value : this.telephone,
      email: data.email.present ? data.email.value : this.email,
      adresse: data.adresse.present ? data.adresse.value : this.adresse,
      note: data.note.present ? data.note.value : this.note,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('telephone: $telephone, ')
          ..write('email: $email, ')
          ..write('adresse: $adresse, ')
          ..write('note: $note, ')
          ..write('remoteId: $remoteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, deletedAt, isSynced,
      nom, prenom, telephone, email, adresse, note, remoteId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isSynced == this.isSynced &&
          other.nom == this.nom &&
          other.prenom == this.prenom &&
          other.telephone == this.telephone &&
          other.email == this.email &&
          other.adresse == this.adresse &&
          other.note == this.note &&
          other.remoteId == this.remoteId);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> isSynced;
  final Value<String> nom;
  final Value<String?> prenom;
  final Value<String?> telephone;
  final Value<String?> email;
  final Value<String?> adresse;
  final Value<String?> note;
  final Value<String?> remoteId;
  final Value<int> rowid;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.nom = const Value.absent(),
    this.prenom = const Value.absent(),
    this.telephone = const Value.absent(),
    this.email = const Value.absent(),
    this.adresse = const Value.absent(),
    this.note = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    required String nom,
    this.prenom = const Value.absent(),
    this.telephone = const Value.absent(),
    this.email = const Value.absent(),
    this.adresse = const Value.absent(),
    this.note = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : nom = Value(nom);
  static Insertable<Client> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? isSynced,
    Expression<String>? nom,
    Expression<String>? prenom,
    Expression<String>? telephone,
    Expression<String>? email,
    Expression<String>? adresse,
    Expression<String>? note,
    Expression<String>? remoteId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (nom != null) 'nom': nom,
      if (prenom != null) 'prenom': prenom,
      if (telephone != null) 'telephone': telephone,
      if (email != null) 'email': email,
      if (adresse != null) 'adresse': adresse,
      if (note != null) 'note': note,
      if (remoteId != null) 'remote_id': remoteId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<bool>? isSynced,
      Value<String>? nom,
      Value<String?>? prenom,
      Value<String?>? telephone,
      Value<String?>? email,
      Value<String?>? adresse,
      Value<String?>? note,
      Value<String?>? remoteId,
      Value<int>? rowid}) {
    return ClientsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      adresse: adresse ?? this.adresse,
      note: note ?? this.note,
      remoteId: remoteId ?? this.remoteId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (prenom.present) {
      map['prenom'] = Variable<String>(prenom.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (adresse.present) {
      map['adresse'] = Variable<String>(adresse.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('telephone: $telephone, ')
          ..write('email: $email, ')
          ..write('adresse: $adresse, ')
          ..write('note: $note, ')
          ..write('remoteId: $remoteId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FichesMesuresTable extends FichesMesures
    with TableInfo<$FichesMesuresTable, FichesMesure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FichesMesuresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => uuidGenerator.v4());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES clients (id) ON DELETE CASCADE'));
  static const VerificationMeta _libelleMeta =
      const VerificationMeta('libelle');
  @override
  late final GeneratedColumn<String> libelle = GeneratedColumn<String>(
      'libelle', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _datePriseMeta =
      const VerificationMeta('datePrise');
  @override
  late final GeneratedColumn<DateTime> datePrise = GeneratedColumn<DateTime>(
      'date_prise', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        deletedAt,
        isSynced,
        clientId,
        libelle,
        remoteId,
        datePrise
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fiches_mesures';
  @override
  VerificationContext validateIntegrity(Insertable<FichesMesure> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('libelle')) {
      context.handle(_libelleMeta,
          libelle.isAcceptableOrUnknown(data['libelle']!, _libelleMeta));
    } else if (isInserting) {
      context.missing(_libelleMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('date_prise')) {
      context.handle(_datePriseMeta,
          datePrise.isAcceptableOrUnknown(data['date_prise']!, _datePriseMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FichesMesure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FichesMesure(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      libelle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}libelle'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      datePrise: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_prise'])!,
    );
  }

  @override
  $FichesMesuresTable createAlias(String alias) {
    return $FichesMesuresTable(attachedDatabase, alias);
  }
}

class FichesMesure extends DataClass implements Insertable<FichesMesure> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isSynced;
  final String clientId;
  final String libelle;

  /// UUID de la ressource côté API (null tant qu'elle n'a pas été envoyée).
  final String? remoteId;
  final DateTime datePrise;
  const FichesMesure(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.isSynced,
      required this.clientId,
      required this.libelle,
      this.remoteId,
      required this.datePrise});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['client_id'] = Variable<String>(clientId);
    map['libelle'] = Variable<String>(libelle);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['date_prise'] = Variable<DateTime>(datePrise);
    return map;
  }

  FichesMesuresCompanion toCompanion(bool nullToAbsent) {
    return FichesMesuresCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isSynced: Value(isSynced),
      clientId: Value(clientId),
      libelle: Value(libelle),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      datePrise: Value(datePrise),
    );
  }

  factory FichesMesure.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FichesMesure(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      clientId: serializer.fromJson<String>(json['clientId']),
      libelle: serializer.fromJson<String>(json['libelle']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      datePrise: serializer.fromJson<DateTime>(json['datePrise']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'clientId': serializer.toJson<String>(clientId),
      'libelle': serializer.toJson<String>(libelle),
      'remoteId': serializer.toJson<String?>(remoteId),
      'datePrise': serializer.toJson<DateTime>(datePrise),
    };
  }

  FichesMesure copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          bool? isSynced,
          String? clientId,
          String? libelle,
          Value<String?> remoteId = const Value.absent(),
          DateTime? datePrise}) =>
      FichesMesure(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        isSynced: isSynced ?? this.isSynced,
        clientId: clientId ?? this.clientId,
        libelle: libelle ?? this.libelle,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        datePrise: datePrise ?? this.datePrise,
      );
  FichesMesure copyWithCompanion(FichesMesuresCompanion data) {
    return FichesMesure(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      libelle: data.libelle.present ? data.libelle.value : this.libelle,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      datePrise: data.datePrise.present ? data.datePrise.value : this.datePrise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FichesMesure(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('clientId: $clientId, ')
          ..write('libelle: $libelle, ')
          ..write('remoteId: $remoteId, ')
          ..write('datePrise: $datePrise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, deletedAt, isSynced,
      clientId, libelle, remoteId, datePrise);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FichesMesure &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isSynced == this.isSynced &&
          other.clientId == this.clientId &&
          other.libelle == this.libelle &&
          other.remoteId == this.remoteId &&
          other.datePrise == this.datePrise);
}

class FichesMesuresCompanion extends UpdateCompanion<FichesMesure> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> isSynced;
  final Value<String> clientId;
  final Value<String> libelle;
  final Value<String?> remoteId;
  final Value<DateTime> datePrise;
  final Value<int> rowid;
  const FichesMesuresCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.clientId = const Value.absent(),
    this.libelle = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.datePrise = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FichesMesuresCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    required String clientId,
    required String libelle,
    this.remoteId = const Value.absent(),
    this.datePrise = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : clientId = Value(clientId),
        libelle = Value(libelle);
  static Insertable<FichesMesure> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? isSynced,
    Expression<String>? clientId,
    Expression<String>? libelle,
    Expression<String>? remoteId,
    Expression<DateTime>? datePrise,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (clientId != null) 'client_id': clientId,
      if (libelle != null) 'libelle': libelle,
      if (remoteId != null) 'remote_id': remoteId,
      if (datePrise != null) 'date_prise': datePrise,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FichesMesuresCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<bool>? isSynced,
      Value<String>? clientId,
      Value<String>? libelle,
      Value<String?>? remoteId,
      Value<DateTime>? datePrise,
      Value<int>? rowid}) {
    return FichesMesuresCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
      clientId: clientId ?? this.clientId,
      libelle: libelle ?? this.libelle,
      remoteId: remoteId ?? this.remoteId,
      datePrise: datePrise ?? this.datePrise,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (libelle.present) {
      map['libelle'] = Variable<String>(libelle.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (datePrise.present) {
      map['date_prise'] = Variable<DateTime>(datePrise.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FichesMesuresCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('clientId: $clientId, ')
          ..write('libelle: $libelle, ')
          ..write('remoteId: $remoteId, ')
          ..write('datePrise: $datePrise, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MesuresTable extends Mesures with TableInfo<$MesuresTable, Mesure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MesuresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => uuidGenerator.v4());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _ficheIdMeta =
      const VerificationMeta('ficheId');
  @override
  late final GeneratedColumn<String> ficheId = GeneratedColumn<String>(
      'fiche_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES fiches_mesures (id) ON DELETE CASCADE'));
  static const VerificationMeta _nomMesureMeta =
      const VerificationMeta('nomMesure');
  @override
  late final GeneratedColumn<String> nomMesure = GeneratedColumn<String>(
      'nom_mesure', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _valeurMeta = const VerificationMeta('valeur');
  @override
  late final GeneratedColumn<double> valeur = GeneratedColumn<double>(
      'valeur', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _uniteMeta = const VerificationMeta('unite');
  @override
  late final GeneratedColumn<String> unite = GeneratedColumn<String>(
      'unite', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cm'));
  static const VerificationMeta _ordreMeta = const VerificationMeta('ordre');
  @override
  late final GeneratedColumn<int> ordre = GeneratedColumn<int>(
      'ordre', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        deletedAt,
        isSynced,
        ficheId,
        nomMesure,
        valeur,
        unite,
        ordre
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mesures';
  @override
  VerificationContext validateIntegrity(Insertable<Mesure> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('fiche_id')) {
      context.handle(_ficheIdMeta,
          ficheId.isAcceptableOrUnknown(data['fiche_id']!, _ficheIdMeta));
    } else if (isInserting) {
      context.missing(_ficheIdMeta);
    }
    if (data.containsKey('nom_mesure')) {
      context.handle(_nomMesureMeta,
          nomMesure.isAcceptableOrUnknown(data['nom_mesure']!, _nomMesureMeta));
    } else if (isInserting) {
      context.missing(_nomMesureMeta);
    }
    if (data.containsKey('valeur')) {
      context.handle(_valeurMeta,
          valeur.isAcceptableOrUnknown(data['valeur']!, _valeurMeta));
    } else if (isInserting) {
      context.missing(_valeurMeta);
    }
    if (data.containsKey('unite')) {
      context.handle(
          _uniteMeta, unite.isAcceptableOrUnknown(data['unite']!, _uniteMeta));
    }
    if (data.containsKey('ordre')) {
      context.handle(
          _ordreMeta, ordre.isAcceptableOrUnknown(data['ordre']!, _ordreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mesure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mesure(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      ficheId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fiche_id'])!,
      nomMesure: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom_mesure'])!,
      valeur: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}valeur'])!,
      unite: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unite'])!,
      ordre: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ordre'])!,
    );
  }

  @override
  $MesuresTable createAlias(String alias) {
    return $MesuresTable(attachedDatabase, alias);
  }
}

class Mesure extends DataClass implements Insertable<Mesure> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isSynced;
  final String ficheId;
  final String nomMesure;
  final double valeur;
  final String unite;
  final int ordre;
  const Mesure(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.isSynced,
      required this.ficheId,
      required this.nomMesure,
      required this.valeur,
      required this.unite,
      required this.ordre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['fiche_id'] = Variable<String>(ficheId);
    map['nom_mesure'] = Variable<String>(nomMesure);
    map['valeur'] = Variable<double>(valeur);
    map['unite'] = Variable<String>(unite);
    map['ordre'] = Variable<int>(ordre);
    return map;
  }

  MesuresCompanion toCompanion(bool nullToAbsent) {
    return MesuresCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isSynced: Value(isSynced),
      ficheId: Value(ficheId),
      nomMesure: Value(nomMesure),
      valeur: Value(valeur),
      unite: Value(unite),
      ordre: Value(ordre),
    );
  }

  factory Mesure.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mesure(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      ficheId: serializer.fromJson<String>(json['ficheId']),
      nomMesure: serializer.fromJson<String>(json['nomMesure']),
      valeur: serializer.fromJson<double>(json['valeur']),
      unite: serializer.fromJson<String>(json['unite']),
      ordre: serializer.fromJson<int>(json['ordre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'ficheId': serializer.toJson<String>(ficheId),
      'nomMesure': serializer.toJson<String>(nomMesure),
      'valeur': serializer.toJson<double>(valeur),
      'unite': serializer.toJson<String>(unite),
      'ordre': serializer.toJson<int>(ordre),
    };
  }

  Mesure copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          bool? isSynced,
          String? ficheId,
          String? nomMesure,
          double? valeur,
          String? unite,
          int? ordre}) =>
      Mesure(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        isSynced: isSynced ?? this.isSynced,
        ficheId: ficheId ?? this.ficheId,
        nomMesure: nomMesure ?? this.nomMesure,
        valeur: valeur ?? this.valeur,
        unite: unite ?? this.unite,
        ordre: ordre ?? this.ordre,
      );
  Mesure copyWithCompanion(MesuresCompanion data) {
    return Mesure(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      ficheId: data.ficheId.present ? data.ficheId.value : this.ficheId,
      nomMesure: data.nomMesure.present ? data.nomMesure.value : this.nomMesure,
      valeur: data.valeur.present ? data.valeur.value : this.valeur,
      unite: data.unite.present ? data.unite.value : this.unite,
      ordre: data.ordre.present ? data.ordre.value : this.ordre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mesure(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('ficheId: $ficheId, ')
          ..write('nomMesure: $nomMesure, ')
          ..write('valeur: $valeur, ')
          ..write('unite: $unite, ')
          ..write('ordre: $ordre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, deletedAt, isSynced,
      ficheId, nomMesure, valeur, unite, ordre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mesure &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isSynced == this.isSynced &&
          other.ficheId == this.ficheId &&
          other.nomMesure == this.nomMesure &&
          other.valeur == this.valeur &&
          other.unite == this.unite &&
          other.ordre == this.ordre);
}

class MesuresCompanion extends UpdateCompanion<Mesure> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> isSynced;
  final Value<String> ficheId;
  final Value<String> nomMesure;
  final Value<double> valeur;
  final Value<String> unite;
  final Value<int> ordre;
  final Value<int> rowid;
  const MesuresCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.ficheId = const Value.absent(),
    this.nomMesure = const Value.absent(),
    this.valeur = const Value.absent(),
    this.unite = const Value.absent(),
    this.ordre = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MesuresCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    required String ficheId,
    required String nomMesure,
    required double valeur,
    this.unite = const Value.absent(),
    this.ordre = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : ficheId = Value(ficheId),
        nomMesure = Value(nomMesure),
        valeur = Value(valeur);
  static Insertable<Mesure> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? isSynced,
    Expression<String>? ficheId,
    Expression<String>? nomMesure,
    Expression<double>? valeur,
    Expression<String>? unite,
    Expression<int>? ordre,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (ficheId != null) 'fiche_id': ficheId,
      if (nomMesure != null) 'nom_mesure': nomMesure,
      if (valeur != null) 'valeur': valeur,
      if (unite != null) 'unite': unite,
      if (ordre != null) 'ordre': ordre,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MesuresCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<bool>? isSynced,
      Value<String>? ficheId,
      Value<String>? nomMesure,
      Value<double>? valeur,
      Value<String>? unite,
      Value<int>? ordre,
      Value<int>? rowid}) {
    return MesuresCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
      ficheId: ficheId ?? this.ficheId,
      nomMesure: nomMesure ?? this.nomMesure,
      valeur: valeur ?? this.valeur,
      unite: unite ?? this.unite,
      ordre: ordre ?? this.ordre,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (ficheId.present) {
      map['fiche_id'] = Variable<String>(ficheId.value);
    }
    if (nomMesure.present) {
      map['nom_mesure'] = Variable<String>(nomMesure.value);
    }
    if (valeur.present) {
      map['valeur'] = Variable<double>(valeur.value);
    }
    if (unite.present) {
      map['unite'] = Variable<String>(unite.value);
    }
    if (ordre.present) {
      map['ordre'] = Variable<int>(ordre.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MesuresCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('ficheId: $ficheId, ')
          ..write('nomMesure: $nomMesure, ')
          ..write('valeur: $valeur, ')
          ..write('unite: $unite, ')
          ..write('ordre: $ordre, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModelesTable extends Modeles with TableInfo<$ModelesTable, Modele> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => uuidGenerator.v4());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _prixIndicatifMeta =
      const VerificationMeta('prixIndicatif');
  @override
  late final GeneratedColumn<int> prixIndicatif = GeneratedColumn<int>(
      'prix_indicatif', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _typeVetementMeta =
      const VerificationMeta('typeVetement');
  @override
  late final GeneratedColumn<String> typeVetement = GeneratedColumn<String>(
      'type_vetement', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _estPublieMeta =
      const VerificationMeta('estPublie');
  @override
  late final GeneratedColumn<bool> estPublie = GeneratedColumn<bool>(
      'est_publie', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("est_publie" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        deletedAt,
        isSynced,
        nom,
        description,
        prixIndicatif,
        typeVetement,
        imageUrl,
        estPublie,
        remoteId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modeles';
  @override
  VerificationContext validateIntegrity(Insertable<Modele> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('prix_indicatif')) {
      context.handle(
          _prixIndicatifMeta,
          prixIndicatif.isAcceptableOrUnknown(
              data['prix_indicatif']!, _prixIndicatifMeta));
    }
    if (data.containsKey('type_vetement')) {
      context.handle(
          _typeVetementMeta,
          typeVetement.isAcceptableOrUnknown(
              data['type_vetement']!, _typeVetementMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('est_publie')) {
      context.handle(_estPublieMeta,
          estPublie.isAcceptableOrUnknown(data['est_publie']!, _estPublieMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Modele map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Modele(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      prixIndicatif: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}prix_indicatif']),
      typeVetement: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type_vetement']),
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      estPublie: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}est_publie'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
    );
  }

  @override
  $ModelesTable createAlias(String alias) {
    return $ModelesTable(attachedDatabase, alias);
  }
}

class Modele extends DataClass implements Insertable<Modele> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isSynced;
  final String nom;
  final String? description;

  /// `base_price` côté API.
  final int? prixIndicatif;

  /// `category` côté API (Homme, Femme, Enfant…).
  final String? typeVetement;

  /// `image_url` côté API : photo hébergée, affichée en lecture seule.
  final String? imageUrl;

  /// `is_published` côté API : visible dans le catalogue client.
  final bool estPublie;

  /// UUID de la ressource côté API (null tant qu'elle n'a pas été envoyée).
  final String? remoteId;
  const Modele(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.isSynced,
      required this.nom,
      this.description,
      this.prixIndicatif,
      this.typeVetement,
      this.imageUrl,
      required this.estPublie,
      this.remoteId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['nom'] = Variable<String>(nom);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || prixIndicatif != null) {
      map['prix_indicatif'] = Variable<int>(prixIndicatif);
    }
    if (!nullToAbsent || typeVetement != null) {
      map['type_vetement'] = Variable<String>(typeVetement);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['est_publie'] = Variable<bool>(estPublie);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    return map;
  }

  ModelesCompanion toCompanion(bool nullToAbsent) {
    return ModelesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isSynced: Value(isSynced),
      nom: Value(nom),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      prixIndicatif: prixIndicatif == null && nullToAbsent
          ? const Value.absent()
          : Value(prixIndicatif),
      typeVetement: typeVetement == null && nullToAbsent
          ? const Value.absent()
          : Value(typeVetement),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      estPublie: Value(estPublie),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
    );
  }

  factory Modele.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Modele(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      nom: serializer.fromJson<String>(json['nom']),
      description: serializer.fromJson<String?>(json['description']),
      prixIndicatif: serializer.fromJson<int?>(json['prixIndicatif']),
      typeVetement: serializer.fromJson<String?>(json['typeVetement']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      estPublie: serializer.fromJson<bool>(json['estPublie']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'nom': serializer.toJson<String>(nom),
      'description': serializer.toJson<String?>(description),
      'prixIndicatif': serializer.toJson<int?>(prixIndicatif),
      'typeVetement': serializer.toJson<String?>(typeVetement),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'estPublie': serializer.toJson<bool>(estPublie),
      'remoteId': serializer.toJson<String?>(remoteId),
    };
  }

  Modele copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          bool? isSynced,
          String? nom,
          Value<String?> description = const Value.absent(),
          Value<int?> prixIndicatif = const Value.absent(),
          Value<String?> typeVetement = const Value.absent(),
          Value<String?> imageUrl = const Value.absent(),
          bool? estPublie,
          Value<String?> remoteId = const Value.absent()}) =>
      Modele(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        isSynced: isSynced ?? this.isSynced,
        nom: nom ?? this.nom,
        description: description.present ? description.value : this.description,
        prixIndicatif:
            prixIndicatif.present ? prixIndicatif.value : this.prixIndicatif,
        typeVetement:
            typeVetement.present ? typeVetement.value : this.typeVetement,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        estPublie: estPublie ?? this.estPublie,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
      );
  Modele copyWithCompanion(ModelesCompanion data) {
    return Modele(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      nom: data.nom.present ? data.nom.value : this.nom,
      description:
          data.description.present ? data.description.value : this.description,
      prixIndicatif: data.prixIndicatif.present
          ? data.prixIndicatif.value
          : this.prixIndicatif,
      typeVetement: data.typeVetement.present
          ? data.typeVetement.value
          : this.typeVetement,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      estPublie: data.estPublie.present ? data.estPublie.value : this.estPublie,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Modele(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('nom: $nom, ')
          ..write('description: $description, ')
          ..write('prixIndicatif: $prixIndicatif, ')
          ..write('typeVetement: $typeVetement, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('estPublie: $estPublie, ')
          ..write('remoteId: $remoteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      deletedAt,
      isSynced,
      nom,
      description,
      prixIndicatif,
      typeVetement,
      imageUrl,
      estPublie,
      remoteId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Modele &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isSynced == this.isSynced &&
          other.nom == this.nom &&
          other.description == this.description &&
          other.prixIndicatif == this.prixIndicatif &&
          other.typeVetement == this.typeVetement &&
          other.imageUrl == this.imageUrl &&
          other.estPublie == this.estPublie &&
          other.remoteId == this.remoteId);
}

class ModelesCompanion extends UpdateCompanion<Modele> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> isSynced;
  final Value<String> nom;
  final Value<String?> description;
  final Value<int?> prixIndicatif;
  final Value<String?> typeVetement;
  final Value<String?> imageUrl;
  final Value<bool> estPublie;
  final Value<String?> remoteId;
  final Value<int> rowid;
  const ModelesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.nom = const Value.absent(),
    this.description = const Value.absent(),
    this.prixIndicatif = const Value.absent(),
    this.typeVetement = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.estPublie = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModelesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    required String nom,
    this.description = const Value.absent(),
    this.prixIndicatif = const Value.absent(),
    this.typeVetement = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.estPublie = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : nom = Value(nom);
  static Insertable<Modele> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? isSynced,
    Expression<String>? nom,
    Expression<String>? description,
    Expression<int>? prixIndicatif,
    Expression<String>? typeVetement,
    Expression<String>? imageUrl,
    Expression<bool>? estPublie,
    Expression<String>? remoteId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (nom != null) 'nom': nom,
      if (description != null) 'description': description,
      if (prixIndicatif != null) 'prix_indicatif': prixIndicatif,
      if (typeVetement != null) 'type_vetement': typeVetement,
      if (imageUrl != null) 'image_url': imageUrl,
      if (estPublie != null) 'est_publie': estPublie,
      if (remoteId != null) 'remote_id': remoteId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModelesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<bool>? isSynced,
      Value<String>? nom,
      Value<String?>? description,
      Value<int?>? prixIndicatif,
      Value<String?>? typeVetement,
      Value<String?>? imageUrl,
      Value<bool>? estPublie,
      Value<String?>? remoteId,
      Value<int>? rowid}) {
    return ModelesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      prixIndicatif: prixIndicatif ?? this.prixIndicatif,
      typeVetement: typeVetement ?? this.typeVetement,
      imageUrl: imageUrl ?? this.imageUrl,
      estPublie: estPublie ?? this.estPublie,
      remoteId: remoteId ?? this.remoteId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (prixIndicatif.present) {
      map['prix_indicatif'] = Variable<int>(prixIndicatif.value);
    }
    if (typeVetement.present) {
      map['type_vetement'] = Variable<String>(typeVetement.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (estPublie.present) {
      map['est_publie'] = Variable<bool>(estPublie.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('nom: $nom, ')
          ..write('description: $description, ')
          ..write('prixIndicatif: $prixIndicatif, ')
          ..write('typeVetement: $typeVetement, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('estPublie: $estPublie, ')
          ..write('remoteId: $remoteId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommandesTable extends Commandes
    with TableInfo<$CommandesTable, Commande> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommandesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => uuidGenerator.v4());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES clients (id) ON DELETE RESTRICT'));
  static const VerificationMeta _modeleIdMeta =
      const VerificationMeta('modeleId');
  @override
  late final GeneratedColumn<String> modeleId = GeneratedColumn<String>(
      'modele_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES modeles (id) ON DELETE SET NULL'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _prixConvenuMeta =
      const VerificationMeta('prixConvenu');
  @override
  late final GeneratedColumn<int> prixConvenu = GeneratedColumn<int>(
      'prix_convenu', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateCommandeMeta =
      const VerificationMeta('dateCommande');
  @override
  late final GeneratedColumn<DateTime> dateCommande = GeneratedColumn<DateTime>(
      'date_commande', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _dateEcheanceMeta =
      const VerificationMeta('dateEcheance');
  @override
  late final GeneratedColumn<DateTime> dateEcheance = GeneratedColumn<DateTime>(
      'date_echeance', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<StatutCommande, String> statut =
      GeneratedColumn<String>('statut', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('enAttente'))
          .withConverter<StatutCommande>($CommandesTable.$converterstatut);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statutDistantMeta =
      const VerificationMeta('statutDistant');
  @override
  late final GeneratedColumn<String> statutDistant = GeneratedColumn<String>(
      'statut_distant', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        deletedAt,
        isSynced,
        clientId,
        modeleId,
        description,
        notes,
        prixConvenu,
        dateCommande,
        dateEcheance,
        statut,
        remoteId,
        statutDistant,
        reference
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'commandes';
  @override
  VerificationContext validateIntegrity(Insertable<Commande> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('modele_id')) {
      context.handle(_modeleIdMeta,
          modeleId.isAcceptableOrUnknown(data['modele_id']!, _modeleIdMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('prix_convenu')) {
      context.handle(
          _prixConvenuMeta,
          prixConvenu.isAcceptableOrUnknown(
              data['prix_convenu']!, _prixConvenuMeta));
    } else if (isInserting) {
      context.missing(_prixConvenuMeta);
    }
    if (data.containsKey('date_commande')) {
      context.handle(
          _dateCommandeMeta,
          dateCommande.isAcceptableOrUnknown(
              data['date_commande']!, _dateCommandeMeta));
    }
    if (data.containsKey('date_echeance')) {
      context.handle(
          _dateEcheanceMeta,
          dateEcheance.isAcceptableOrUnknown(
              data['date_echeance']!, _dateEcheanceMeta));
    } else if (isInserting) {
      context.missing(_dateEcheanceMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('statut_distant')) {
      context.handle(
          _statutDistantMeta,
          statutDistant.isAcceptableOrUnknown(
              data['statut_distant']!, _statutDistantMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Commande map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Commande(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      modeleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}modele_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      prixConvenu: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}prix_convenu'])!,
      dateCommande: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_commande'])!,
      dateEcheance: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_echeance'])!,
      statut: $CommandesTable.$converterstatut.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      statutDistant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut_distant']),
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
    );
  }

  @override
  $CommandesTable createAlias(String alias) {
    return $CommandesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StatutCommande, String, String> $converterstatut =
      const EnumNameConverter<StatutCommande>(StatutCommande.values);
}

class Commande extends DataClass implements Insertable<Commande> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isSynced;
  final String clientId;

  /// `catalog_model` côté API.
  final String? modeleId;
  final String? description;
  final String? notes;

  /// Prix de l'article unique de la commande (`items[0].unit_price`).
  final int prixConvenu;
  final DateTime dateCommande;

  /// `due_date` côté API.
  final DateTime dateEcheance;
  final StatutCommande statut;

  /// UUID de la ressource côté API (null tant qu'elle n'a pas été envoyée).
  final String? remoteId;

  /// Statut côté API (draft, confirmed, in_progress, ready, delivered, cancelled).
  final String? statutDistant;

  /// Référence attribuée par le serveur (ex. CMD-2026-0042).
  final String? reference;
  const Commande(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.isSynced,
      required this.clientId,
      this.modeleId,
      this.description,
      this.notes,
      required this.prixConvenu,
      required this.dateCommande,
      required this.dateEcheance,
      required this.statut,
      this.remoteId,
      this.statutDistant,
      this.reference});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || modeleId != null) {
      map['modele_id'] = Variable<String>(modeleId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['prix_convenu'] = Variable<int>(prixConvenu);
    map['date_commande'] = Variable<DateTime>(dateCommande);
    map['date_echeance'] = Variable<DateTime>(dateEcheance);
    {
      map['statut'] =
          Variable<String>($CommandesTable.$converterstatut.toSql(statut));
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    if (!nullToAbsent || statutDistant != null) {
      map['statut_distant'] = Variable<String>(statutDistant);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    return map;
  }

  CommandesCompanion toCompanion(bool nullToAbsent) {
    return CommandesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isSynced: Value(isSynced),
      clientId: Value(clientId),
      modeleId: modeleId == null && nullToAbsent
          ? const Value.absent()
          : Value(modeleId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      prixConvenu: Value(prixConvenu),
      dateCommande: Value(dateCommande),
      dateEcheance: Value(dateEcheance),
      statut: Value(statut),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      statutDistant: statutDistant == null && nullToAbsent
          ? const Value.absent()
          : Value(statutDistant),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
    );
  }

  factory Commande.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Commande(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      clientId: serializer.fromJson<String>(json['clientId']),
      modeleId: serializer.fromJson<String?>(json['modeleId']),
      description: serializer.fromJson<String?>(json['description']),
      notes: serializer.fromJson<String?>(json['notes']),
      prixConvenu: serializer.fromJson<int>(json['prixConvenu']),
      dateCommande: serializer.fromJson<DateTime>(json['dateCommande']),
      dateEcheance: serializer.fromJson<DateTime>(json['dateEcheance']),
      statut: $CommandesTable.$converterstatut
          .fromJson(serializer.fromJson<String>(json['statut'])),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      statutDistant: serializer.fromJson<String?>(json['statutDistant']),
      reference: serializer.fromJson<String?>(json['reference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'clientId': serializer.toJson<String>(clientId),
      'modeleId': serializer.toJson<String?>(modeleId),
      'description': serializer.toJson<String?>(description),
      'notes': serializer.toJson<String?>(notes),
      'prixConvenu': serializer.toJson<int>(prixConvenu),
      'dateCommande': serializer.toJson<DateTime>(dateCommande),
      'dateEcheance': serializer.toJson<DateTime>(dateEcheance),
      'statut': serializer
          .toJson<String>($CommandesTable.$converterstatut.toJson(statut)),
      'remoteId': serializer.toJson<String?>(remoteId),
      'statutDistant': serializer.toJson<String?>(statutDistant),
      'reference': serializer.toJson<String?>(reference),
    };
  }

  Commande copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          bool? isSynced,
          String? clientId,
          Value<String?> modeleId = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          int? prixConvenu,
          DateTime? dateCommande,
          DateTime? dateEcheance,
          StatutCommande? statut,
          Value<String?> remoteId = const Value.absent(),
          Value<String?> statutDistant = const Value.absent(),
          Value<String?> reference = const Value.absent()}) =>
      Commande(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        isSynced: isSynced ?? this.isSynced,
        clientId: clientId ?? this.clientId,
        modeleId: modeleId.present ? modeleId.value : this.modeleId,
        description: description.present ? description.value : this.description,
        notes: notes.present ? notes.value : this.notes,
        prixConvenu: prixConvenu ?? this.prixConvenu,
        dateCommande: dateCommande ?? this.dateCommande,
        dateEcheance: dateEcheance ?? this.dateEcheance,
        statut: statut ?? this.statut,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        statutDistant:
            statutDistant.present ? statutDistant.value : this.statutDistant,
        reference: reference.present ? reference.value : this.reference,
      );
  Commande copyWithCompanion(CommandesCompanion data) {
    return Commande(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      modeleId: data.modeleId.present ? data.modeleId.value : this.modeleId,
      description:
          data.description.present ? data.description.value : this.description,
      notes: data.notes.present ? data.notes.value : this.notes,
      prixConvenu:
          data.prixConvenu.present ? data.prixConvenu.value : this.prixConvenu,
      dateCommande: data.dateCommande.present
          ? data.dateCommande.value
          : this.dateCommande,
      dateEcheance: data.dateEcheance.present
          ? data.dateEcheance.value
          : this.dateEcheance,
      statut: data.statut.present ? data.statut.value : this.statut,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      statutDistant: data.statutDistant.present
          ? data.statutDistant.value
          : this.statutDistant,
      reference: data.reference.present ? data.reference.value : this.reference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Commande(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('clientId: $clientId, ')
          ..write('modeleId: $modeleId, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('prixConvenu: $prixConvenu, ')
          ..write('dateCommande: $dateCommande, ')
          ..write('dateEcheance: $dateEcheance, ')
          ..write('statut: $statut, ')
          ..write('remoteId: $remoteId, ')
          ..write('statutDistant: $statutDistant, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      deletedAt,
      isSynced,
      clientId,
      modeleId,
      description,
      notes,
      prixConvenu,
      dateCommande,
      dateEcheance,
      statut,
      remoteId,
      statutDistant,
      reference);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Commande &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isSynced == this.isSynced &&
          other.clientId == this.clientId &&
          other.modeleId == this.modeleId &&
          other.description == this.description &&
          other.notes == this.notes &&
          other.prixConvenu == this.prixConvenu &&
          other.dateCommande == this.dateCommande &&
          other.dateEcheance == this.dateEcheance &&
          other.statut == this.statut &&
          other.remoteId == this.remoteId &&
          other.statutDistant == this.statutDistant &&
          other.reference == this.reference);
}

class CommandesCompanion extends UpdateCompanion<Commande> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> isSynced;
  final Value<String> clientId;
  final Value<String?> modeleId;
  final Value<String?> description;
  final Value<String?> notes;
  final Value<int> prixConvenu;
  final Value<DateTime> dateCommande;
  final Value<DateTime> dateEcheance;
  final Value<StatutCommande> statut;
  final Value<String?> remoteId;
  final Value<String?> statutDistant;
  final Value<String?> reference;
  final Value<int> rowid;
  const CommandesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.clientId = const Value.absent(),
    this.modeleId = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    this.prixConvenu = const Value.absent(),
    this.dateCommande = const Value.absent(),
    this.dateEcheance = const Value.absent(),
    this.statut = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.statutDistant = const Value.absent(),
    this.reference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommandesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    required String clientId,
    this.modeleId = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    required int prixConvenu,
    this.dateCommande = const Value.absent(),
    required DateTime dateEcheance,
    this.statut = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.statutDistant = const Value.absent(),
    this.reference = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : clientId = Value(clientId),
        prixConvenu = Value(prixConvenu),
        dateEcheance = Value(dateEcheance);
  static Insertable<Commande> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? isSynced,
    Expression<String>? clientId,
    Expression<String>? modeleId,
    Expression<String>? description,
    Expression<String>? notes,
    Expression<int>? prixConvenu,
    Expression<DateTime>? dateCommande,
    Expression<DateTime>? dateEcheance,
    Expression<String>? statut,
    Expression<String>? remoteId,
    Expression<String>? statutDistant,
    Expression<String>? reference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (clientId != null) 'client_id': clientId,
      if (modeleId != null) 'modele_id': modeleId,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      if (prixConvenu != null) 'prix_convenu': prixConvenu,
      if (dateCommande != null) 'date_commande': dateCommande,
      if (dateEcheance != null) 'date_echeance': dateEcheance,
      if (statut != null) 'statut': statut,
      if (remoteId != null) 'remote_id': remoteId,
      if (statutDistant != null) 'statut_distant': statutDistant,
      if (reference != null) 'reference': reference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommandesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<bool>? isSynced,
      Value<String>? clientId,
      Value<String?>? modeleId,
      Value<String?>? description,
      Value<String?>? notes,
      Value<int>? prixConvenu,
      Value<DateTime>? dateCommande,
      Value<DateTime>? dateEcheance,
      Value<StatutCommande>? statut,
      Value<String?>? remoteId,
      Value<String?>? statutDistant,
      Value<String?>? reference,
      Value<int>? rowid}) {
    return CommandesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
      clientId: clientId ?? this.clientId,
      modeleId: modeleId ?? this.modeleId,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      prixConvenu: prixConvenu ?? this.prixConvenu,
      dateCommande: dateCommande ?? this.dateCommande,
      dateEcheance: dateEcheance ?? this.dateEcheance,
      statut: statut ?? this.statut,
      remoteId: remoteId ?? this.remoteId,
      statutDistant: statutDistant ?? this.statutDistant,
      reference: reference ?? this.reference,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (modeleId.present) {
      map['modele_id'] = Variable<String>(modeleId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (prixConvenu.present) {
      map['prix_convenu'] = Variable<int>(prixConvenu.value);
    }
    if (dateCommande.present) {
      map['date_commande'] = Variable<DateTime>(dateCommande.value);
    }
    if (dateEcheance.present) {
      map['date_echeance'] = Variable<DateTime>(dateEcheance.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(
          $CommandesTable.$converterstatut.toSql(statut.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (statutDistant.present) {
      map['statut_distant'] = Variable<String>(statutDistant.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommandesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('clientId: $clientId, ')
          ..write('modeleId: $modeleId, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('prixConvenu: $prixConvenu, ')
          ..write('dateCommande: $dateCommande, ')
          ..write('dateEcheance: $dateEcheance, ')
          ..write('statut: $statut, ')
          ..write('remoteId: $remoteId, ')
          ..write('statutDistant: $statutDistant, ')
          ..write('reference: $reference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaiementsTable extends Paiements
    with TableInfo<$PaiementsTable, Paiement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaiementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => uuidGenerator.v4());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _commandeIdMeta =
      const VerificationMeta('commandeId');
  @override
  late final GeneratedColumn<String> commandeId = GeneratedColumn<String>(
      'commande_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES commandes (id) ON DELETE CASCADE'));
  static const VerificationMeta _montantMeta =
      const VerificationMeta('montant');
  @override
  late final GeneratedColumn<int> montant = GeneratedColumn<int>(
      'montant', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _datePaiementMeta =
      const VerificationMeta('datePaiement');
  @override
  late final GeneratedColumn<DateTime> datePaiement = GeneratedColumn<DateTime>(
      'date_paiement', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumnWithTypeConverter<ModePaiement, String> mode =
      GeneratedColumn<String>('mode', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('especes'))
          .withConverter<ModePaiement>($PaiementsTable.$convertermode);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(StatutPaiement.reussi));
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statutDistantMeta =
      const VerificationMeta('statutDistant');
  @override
  late final GeneratedColumn<String> statutDistant = GeneratedColumn<String>(
      'statut_distant', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numeroRecuMeta =
      const VerificationMeta('numeroRecu');
  @override
  late final GeneratedColumn<String> numeroRecu = GeneratedColumn<String>(
      'numero_recu', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updatedAt,
        deletedAt,
        isSynced,
        commandeId,
        montant,
        datePaiement,
        mode,
        note,
        statut,
        reference,
        remoteId,
        statutDistant,
        numeroRecu
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paiements';
  @override
  VerificationContext validateIntegrity(Insertable<Paiement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('commande_id')) {
      context.handle(
          _commandeIdMeta,
          commandeId.isAcceptableOrUnknown(
              data['commande_id']!, _commandeIdMeta));
    } else if (isInserting) {
      context.missing(_commandeIdMeta);
    }
    if (data.containsKey('montant')) {
      context.handle(_montantMeta,
          montant.isAcceptableOrUnknown(data['montant']!, _montantMeta));
    } else if (isInserting) {
      context.missing(_montantMeta);
    }
    if (data.containsKey('date_paiement')) {
      context.handle(
          _datePaiementMeta,
          datePaiement.isAcceptableOrUnknown(
              data['date_paiement']!, _datePaiementMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('statut_distant')) {
      context.handle(
          _statutDistantMeta,
          statutDistant.isAcceptableOrUnknown(
              data['statut_distant']!, _statutDistantMeta));
    }
    if (data.containsKey('numero_recu')) {
      context.handle(
          _numeroRecuMeta,
          numeroRecu.isAcceptableOrUnknown(
              data['numero_recu']!, _numeroRecuMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Paiement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Paiement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      commandeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}commande_id'])!,
      montant: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}montant'])!,
      datePaiement: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_paiement'])!,
      mode: $PaiementsTable.$convertermode.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      statutDistant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut_distant']),
      numeroRecu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero_recu']),
    );
  }

  @override
  $PaiementsTable createAlias(String alias) {
    return $PaiementsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ModePaiement, String, String> $convertermode =
      const EnumNameConverter<ModePaiement>(ModePaiement.values);
}

class Paiement extends DataClass implements Insertable<Paiement> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isSynced;
  final String commandeId;
  final int montant;
  final DateTime datePaiement;
  final ModePaiement mode;
  final String? note;

  /// Seuls les paiements `reussi` comptent dans les encaissements.
  final String statut;

  /// `transaction_reference` côté API (référence du SMS Mobile Money…).
  final String? reference;

  /// UUID de la ressource côté API (null tant qu'elle n'a pas été envoyée).
  final String? remoteId;

  /// Statut côté API (pending, confirmed, failed, cancelled, refunded).
  final String? statutDistant;

  /// Numéro de reçu attribué à la confirmation (ex. REC-2026-00042).
  final String? numeroRecu;
  const Paiement(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.isSynced,
      required this.commandeId,
      required this.montant,
      required this.datePaiement,
      required this.mode,
      this.note,
      required this.statut,
      this.reference,
      this.remoteId,
      this.statutDistant,
      this.numeroRecu});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['commande_id'] = Variable<String>(commandeId);
    map['montant'] = Variable<int>(montant);
    map['date_paiement'] = Variable<DateTime>(datePaiement);
    {
      map['mode'] =
          Variable<String>($PaiementsTable.$convertermode.toSql(mode));
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['statut'] = Variable<String>(statut);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    if (!nullToAbsent || statutDistant != null) {
      map['statut_distant'] = Variable<String>(statutDistant);
    }
    if (!nullToAbsent || numeroRecu != null) {
      map['numero_recu'] = Variable<String>(numeroRecu);
    }
    return map;
  }

  PaiementsCompanion toCompanion(bool nullToAbsent) {
    return PaiementsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isSynced: Value(isSynced),
      commandeId: Value(commandeId),
      montant: Value(montant),
      datePaiement: Value(datePaiement),
      mode: Value(mode),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      statut: Value(statut),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      statutDistant: statutDistant == null && nullToAbsent
          ? const Value.absent()
          : Value(statutDistant),
      numeroRecu: numeroRecu == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroRecu),
    );
  }

  factory Paiement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Paiement(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      commandeId: serializer.fromJson<String>(json['commandeId']),
      montant: serializer.fromJson<int>(json['montant']),
      datePaiement: serializer.fromJson<DateTime>(json['datePaiement']),
      mode: $PaiementsTable.$convertermode
          .fromJson(serializer.fromJson<String>(json['mode'])),
      note: serializer.fromJson<String?>(json['note']),
      statut: serializer.fromJson<String>(json['statut']),
      reference: serializer.fromJson<String?>(json['reference']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      statutDistant: serializer.fromJson<String?>(json['statutDistant']),
      numeroRecu: serializer.fromJson<String?>(json['numeroRecu']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'commandeId': serializer.toJson<String>(commandeId),
      'montant': serializer.toJson<int>(montant),
      'datePaiement': serializer.toJson<DateTime>(datePaiement),
      'mode': serializer
          .toJson<String>($PaiementsTable.$convertermode.toJson(mode)),
      'note': serializer.toJson<String?>(note),
      'statut': serializer.toJson<String>(statut),
      'reference': serializer.toJson<String?>(reference),
      'remoteId': serializer.toJson<String?>(remoteId),
      'statutDistant': serializer.toJson<String?>(statutDistant),
      'numeroRecu': serializer.toJson<String?>(numeroRecu),
    };
  }

  Paiement copyWith(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          bool? isSynced,
          String? commandeId,
          int? montant,
          DateTime? datePaiement,
          ModePaiement? mode,
          Value<String?> note = const Value.absent(),
          String? statut,
          Value<String?> reference = const Value.absent(),
          Value<String?> remoteId = const Value.absent(),
          Value<String?> statutDistant = const Value.absent(),
          Value<String?> numeroRecu = const Value.absent()}) =>
      Paiement(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        isSynced: isSynced ?? this.isSynced,
        commandeId: commandeId ?? this.commandeId,
        montant: montant ?? this.montant,
        datePaiement: datePaiement ?? this.datePaiement,
        mode: mode ?? this.mode,
        note: note.present ? note.value : this.note,
        statut: statut ?? this.statut,
        reference: reference.present ? reference.value : this.reference,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        statutDistant:
            statutDistant.present ? statutDistant.value : this.statutDistant,
        numeroRecu: numeroRecu.present ? numeroRecu.value : this.numeroRecu,
      );
  Paiement copyWithCompanion(PaiementsCompanion data) {
    return Paiement(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      commandeId:
          data.commandeId.present ? data.commandeId.value : this.commandeId,
      montant: data.montant.present ? data.montant.value : this.montant,
      datePaiement: data.datePaiement.present
          ? data.datePaiement.value
          : this.datePaiement,
      mode: data.mode.present ? data.mode.value : this.mode,
      note: data.note.present ? data.note.value : this.note,
      statut: data.statut.present ? data.statut.value : this.statut,
      reference: data.reference.present ? data.reference.value : this.reference,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      statutDistant: data.statutDistant.present
          ? data.statutDistant.value
          : this.statutDistant,
      numeroRecu:
          data.numeroRecu.present ? data.numeroRecu.value : this.numeroRecu,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Paiement(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('commandeId: $commandeId, ')
          ..write('montant: $montant, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('mode: $mode, ')
          ..write('note: $note, ')
          ..write('statut: $statut, ')
          ..write('reference: $reference, ')
          ..write('remoteId: $remoteId, ')
          ..write('statutDistant: $statutDistant, ')
          ..write('numeroRecu: $numeroRecu')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      updatedAt,
      deletedAt,
      isSynced,
      commandeId,
      montant,
      datePaiement,
      mode,
      note,
      statut,
      reference,
      remoteId,
      statutDistant,
      numeroRecu);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Paiement &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isSynced == this.isSynced &&
          other.commandeId == this.commandeId &&
          other.montant == this.montant &&
          other.datePaiement == this.datePaiement &&
          other.mode == this.mode &&
          other.note == this.note &&
          other.statut == this.statut &&
          other.reference == this.reference &&
          other.remoteId == this.remoteId &&
          other.statutDistant == this.statutDistant &&
          other.numeroRecu == this.numeroRecu);
}

class PaiementsCompanion extends UpdateCompanion<Paiement> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> isSynced;
  final Value<String> commandeId;
  final Value<int> montant;
  final Value<DateTime> datePaiement;
  final Value<ModePaiement> mode;
  final Value<String?> note;
  final Value<String> statut;
  final Value<String?> reference;
  final Value<String?> remoteId;
  final Value<String?> statutDistant;
  final Value<String?> numeroRecu;
  final Value<int> rowid;
  const PaiementsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.commandeId = const Value.absent(),
    this.montant = const Value.absent(),
    this.datePaiement = const Value.absent(),
    this.mode = const Value.absent(),
    this.note = const Value.absent(),
    this.statut = const Value.absent(),
    this.reference = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.statutDistant = const Value.absent(),
    this.numeroRecu = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaiementsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    required String commandeId,
    required int montant,
    this.datePaiement = const Value.absent(),
    this.mode = const Value.absent(),
    this.note = const Value.absent(),
    this.statut = const Value.absent(),
    this.reference = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.statutDistant = const Value.absent(),
    this.numeroRecu = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : commandeId = Value(commandeId),
        montant = Value(montant);
  static Insertable<Paiement> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? isSynced,
    Expression<String>? commandeId,
    Expression<int>? montant,
    Expression<DateTime>? datePaiement,
    Expression<String>? mode,
    Expression<String>? note,
    Expression<String>? statut,
    Expression<String>? reference,
    Expression<String>? remoteId,
    Expression<String>? statutDistant,
    Expression<String>? numeroRecu,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (commandeId != null) 'commande_id': commandeId,
      if (montant != null) 'montant': montant,
      if (datePaiement != null) 'date_paiement': datePaiement,
      if (mode != null) 'mode': mode,
      if (note != null) 'note': note,
      if (statut != null) 'statut': statut,
      if (reference != null) 'reference': reference,
      if (remoteId != null) 'remote_id': remoteId,
      if (statutDistant != null) 'statut_distant': statutDistant,
      if (numeroRecu != null) 'numero_recu': numeroRecu,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaiementsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<bool>? isSynced,
      Value<String>? commandeId,
      Value<int>? montant,
      Value<DateTime>? datePaiement,
      Value<ModePaiement>? mode,
      Value<String?>? note,
      Value<String>? statut,
      Value<String?>? reference,
      Value<String?>? remoteId,
      Value<String?>? statutDistant,
      Value<String?>? numeroRecu,
      Value<int>? rowid}) {
    return PaiementsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
      commandeId: commandeId ?? this.commandeId,
      montant: montant ?? this.montant,
      datePaiement: datePaiement ?? this.datePaiement,
      mode: mode ?? this.mode,
      note: note ?? this.note,
      statut: statut ?? this.statut,
      reference: reference ?? this.reference,
      remoteId: remoteId ?? this.remoteId,
      statutDistant: statutDistant ?? this.statutDistant,
      numeroRecu: numeroRecu ?? this.numeroRecu,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (commandeId.present) {
      map['commande_id'] = Variable<String>(commandeId.value);
    }
    if (montant.present) {
      map['montant'] = Variable<int>(montant.value);
    }
    if (datePaiement.present) {
      map['date_paiement'] = Variable<DateTime>(datePaiement.value);
    }
    if (mode.present) {
      map['mode'] =
          Variable<String>($PaiementsTable.$convertermode.toSql(mode.value));
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (statutDistant.present) {
      map['statut_distant'] = Variable<String>(statutDistant.value);
    }
    if (numeroRecu.present) {
      map['numero_recu'] = Variable<String>(numeroRecu.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaiementsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('commandeId: $commandeId, ')
          ..write('montant: $montant, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('mode: $mode, ')
          ..write('note: $note, ')
          ..write('statut: $statut, ')
          ..write('reference: $reference, ')
          ..write('remoteId: $remoteId, ')
          ..write('statutDistant: $statutDistant, ')
          ..write('numeroRecu: $numeroRecu, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SalonsTable salons = $SalonsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $FichesMesuresTable fichesMesures = $FichesMesuresTable(this);
  late final $MesuresTable mesures = $MesuresTable(this);
  late final $ModelesTable modeles = $ModelesTable(this);
  late final $CommandesTable commandes = $CommandesTable(this);
  late final $PaiementsTable paiements = $PaiementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        salons,
        users,
        clients,
        fichesMesures,
        mesures,
        modeles,
        commandes,
        paiements
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('clients',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('fiches_mesures', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('fiches_mesures',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('mesures', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('modeles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('commandes', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('commandes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('paiements', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$SalonsTableCreateCompanionBuilder = SalonsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  required String nom,
  Value<String?> email,
  Value<String?> telephone,
  Value<String?> adresse,
  Value<String> devise,
  Value<int> rowid,
});
typedef $$SalonsTableUpdateCompanionBuilder = SalonsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  Value<String> nom,
  Value<String?> email,
  Value<String?> telephone,
  Value<String?> adresse,
  Value<String> devise,
  Value<int> rowid,
});

class $$SalonsTableFilterComposer
    extends Composer<_$AppDatabase, $SalonsTable> {
  $$SalonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get adresse => $composableBuilder(
      column: $table.adresse, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get devise => $composableBuilder(
      column: $table.devise, builder: (column) => ColumnFilters(column));
}

class $$SalonsTableOrderingComposer
    extends Composer<_$AppDatabase, $SalonsTable> {
  $$SalonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get adresse => $composableBuilder(
      column: $table.adresse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get devise => $composableBuilder(
      column: $table.devise, builder: (column) => ColumnOrderings(column));
}

class $$SalonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalonsTable> {
  $$SalonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<String> get adresse =>
      $composableBuilder(column: $table.adresse, builder: (column) => column);

  GeneratedColumn<String> get devise =>
      $composableBuilder(column: $table.devise, builder: (column) => column);
}

class $$SalonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalonsTable,
    Salon,
    $$SalonsTableFilterComposer,
    $$SalonsTableOrderingComposer,
    $$SalonsTableAnnotationComposer,
    $$SalonsTableCreateCompanionBuilder,
    $$SalonsTableUpdateCompanionBuilder,
    (Salon, BaseReferences<_$AppDatabase, $SalonsTable, Salon>),
    Salon,
    PrefetchHooks Function()> {
  $$SalonsTableTableManager(_$AppDatabase db, $SalonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> telephone = const Value.absent(),
            Value<String?> adresse = const Value.absent(),
            Value<String> devise = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalonsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            nom: nom,
            email: email,
            telephone: telephone,
            adresse: adresse,
            devise: devise,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            required String nom,
            Value<String?> email = const Value.absent(),
            Value<String?> telephone = const Value.absent(),
            Value<String?> adresse = const Value.absent(),
            Value<String> devise = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalonsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            nom: nom,
            email: email,
            telephone: telephone,
            adresse: adresse,
            devise: devise,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SalonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalonsTable,
    Salon,
    $$SalonsTableFilterComposer,
    $$SalonsTableOrderingComposer,
    $$SalonsTableAnnotationComposer,
    $$SalonsTableCreateCompanionBuilder,
    $$SalonsTableUpdateCompanionBuilder,
    (Salon, BaseReferences<_$AppDatabase, $SalonsTable, Salon>),
    Salon,
    PrefetchHooks Function()>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  required String username,
  Value<String?> email,
  Value<String?> firstName,
  Value<String?> lastName,
  Value<String?> telephone,
  Value<RoleMembre> role,
  Value<bool> estActif,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  Value<String> username,
  Value<String?> email,
  Value<String?> firstName,
  Value<String?> lastName,
  Value<String?> telephone,
  Value<RoleMembre> role,
  Value<bool> estActif,
  Value<int> rowid,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RoleMembre, RoleMembre, String> get role =>
      $composableBuilder(
          column: $table.role,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get estActif => $composableBuilder(
      column: $table.estActif, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get estActif => $composableBuilder(
      column: $table.estActif, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RoleMembre, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get estActif =>
      $composableBuilder(column: $table.estActif, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> firstName = const Value.absent(),
            Value<String?> lastName = const Value.absent(),
            Value<String?> telephone = const Value.absent(),
            Value<RoleMembre> role = const Value.absent(),
            Value<bool> estActif = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            username: username,
            email: email,
            firstName: firstName,
            lastName: lastName,
            telephone: telephone,
            role: role,
            estActif: estActif,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            required String username,
            Value<String?> email = const Value.absent(),
            Value<String?> firstName = const Value.absent(),
            Value<String?> lastName = const Value.absent(),
            Value<String?> telephone = const Value.absent(),
            Value<RoleMembre> role = const Value.absent(),
            Value<bool> estActif = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            username: username,
            email: email,
            firstName: firstName,
            lastName: lastName,
            telephone: telephone,
            role: role,
            estActif: estActif,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$ClientsTableCreateCompanionBuilder = ClientsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  required String nom,
  Value<String?> prenom,
  Value<String?> telephone,
  Value<String?> email,
  Value<String?> adresse,
  Value<String?> note,
  Value<String?> remoteId,
  Value<int> rowid,
});
typedef $$ClientsTableUpdateCompanionBuilder = ClientsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  Value<String> nom,
  Value<String?> prenom,
  Value<String?> telephone,
  Value<String?> email,
  Value<String?> adresse,
  Value<String?> note,
  Value<String?> remoteId,
  Value<int> rowid,
});

final class $$ClientsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientsTable, Client> {
  $$ClientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FichesMesuresTable, List<FichesMesure>>
      _fichesMesuresRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.fichesMesures,
              aliasName: $_aliasNameGenerator(
                  db.clients.id, db.fichesMesures.clientId));

  $$FichesMesuresTableProcessedTableManager get fichesMesuresRefs {
    final manager = $$FichesMesuresTableTableManager($_db, $_db.fichesMesures)
        .filter((f) => f.clientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_fichesMesuresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CommandesTable, List<Commande>>
      _commandesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.commandes,
              aliasName:
                  $_aliasNameGenerator(db.clients.id, db.commandes.clientId));

  $$CommandesTableProcessedTableManager get commandesRefs {
    final manager = $$CommandesTableTableManager($_db, $_db.commandes)
        .filter((f) => f.clientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_commandesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prenom => $composableBuilder(
      column: $table.prenom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get adresse => $composableBuilder(
      column: $table.adresse, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  Expression<bool> fichesMesuresRefs(
      Expression<bool> Function($$FichesMesuresTableFilterComposer f) f) {
    final $$FichesMesuresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.fichesMesures,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FichesMesuresTableFilterComposer(
              $db: $db,
              $table: $db.fichesMesures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> commandesRefs(
      Expression<bool> Function($$CommandesTableFilterComposer f) f) {
    final $$CommandesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.commandes,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CommandesTableFilterComposer(
              $db: $db,
              $table: $db.commandes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prenom => $composableBuilder(
      column: $table.prenom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get adresse => $composableBuilder(
      column: $table.adresse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get prenom =>
      $composableBuilder(column: $table.prenom, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get adresse =>
      $composableBuilder(column: $table.adresse, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  Expression<T> fichesMesuresRefs<T extends Object>(
      Expression<T> Function($$FichesMesuresTableAnnotationComposer a) f) {
    final $$FichesMesuresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.fichesMesures,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FichesMesuresTableAnnotationComposer(
              $db: $db,
              $table: $db.fichesMesures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> commandesRefs<T extends Object>(
      Expression<T> Function($$CommandesTableAnnotationComposer a) f) {
    final $$CommandesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.commandes,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CommandesTableAnnotationComposer(
              $db: $db,
              $table: $db.commandes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientsTable,
    Client,
    $$ClientsTableFilterComposer,
    $$ClientsTableOrderingComposer,
    $$ClientsTableAnnotationComposer,
    $$ClientsTableCreateCompanionBuilder,
    $$ClientsTableUpdateCompanionBuilder,
    (Client, $$ClientsTableReferences),
    Client,
    PrefetchHooks Function({bool fichesMesuresRefs, bool commandesRefs})> {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String?> prenom = const Value.absent(),
            Value<String?> telephone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> adresse = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            nom: nom,
            prenom: prenom,
            telephone: telephone,
            email: email,
            adresse: adresse,
            note: note,
            remoteId: remoteId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            required String nom,
            Value<String?> prenom = const Value.absent(),
            Value<String?> telephone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> adresse = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            nom: nom,
            prenom: prenom,
            telephone: telephone,
            email: email,
            adresse: adresse,
            note: note,
            remoteId: remoteId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ClientsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {fichesMesuresRefs = false, commandesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (fichesMesuresRefs) db.fichesMesures,
                if (commandesRefs) db.commandes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (fichesMesuresRefs)
                    await $_getPrefetchedData<Client, $ClientsTable,
                            FichesMesure>(
                        currentTable: table,
                        referencedTable: $$ClientsTableReferences
                            ._fichesMesuresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClientsTableReferences(db, table, p0)
                                .fichesMesuresRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.clientId == item.id),
                        typedResults: items),
                  if (commandesRefs)
                    await $_getPrefetchedData<Client, $ClientsTable, Commande>(
                        currentTable: table,
                        referencedTable:
                            $$ClientsTableReferences._commandesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClientsTableReferences(db, table, p0)
                                .commandesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.clientId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ClientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientsTable,
    Client,
    $$ClientsTableFilterComposer,
    $$ClientsTableOrderingComposer,
    $$ClientsTableAnnotationComposer,
    $$ClientsTableCreateCompanionBuilder,
    $$ClientsTableUpdateCompanionBuilder,
    (Client, $$ClientsTableReferences),
    Client,
    PrefetchHooks Function({bool fichesMesuresRefs, bool commandesRefs})>;
typedef $$FichesMesuresTableCreateCompanionBuilder = FichesMesuresCompanion
    Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  required String clientId,
  required String libelle,
  Value<String?> remoteId,
  Value<DateTime> datePrise,
  Value<int> rowid,
});
typedef $$FichesMesuresTableUpdateCompanionBuilder = FichesMesuresCompanion
    Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  Value<String> clientId,
  Value<String> libelle,
  Value<String?> remoteId,
  Value<DateTime> datePrise,
  Value<int> rowid,
});

final class $$FichesMesuresTableReferences
    extends BaseReferences<_$AppDatabase, $FichesMesuresTable, FichesMesure> {
  $$FichesMesuresTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias(
          $_aliasNameGenerator(db.fichesMesures.clientId, db.clients.id));

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<String>('client_id')!;

    final manager = $$ClientsTableTableManager($_db, $_db.clients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MesuresTable, List<Mesure>> _mesuresRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.mesures,
          aliasName:
              $_aliasNameGenerator(db.fichesMesures.id, db.mesures.ficheId));

  $$MesuresTableProcessedTableManager get mesuresRefs {
    final manager = $$MesuresTableTableManager($_db, $_db.mesures)
        .filter((f) => f.ficheId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mesuresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$FichesMesuresTableFilterComposer
    extends Composer<_$AppDatabase, $FichesMesuresTable> {
  $$FichesMesuresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get libelle => $composableBuilder(
      column: $table.libelle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get datePrise => $composableBuilder(
      column: $table.datePrise, builder: (column) => ColumnFilters(column));

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableFilterComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> mesuresRefs(
      Expression<bool> Function($$MesuresTableFilterComposer f) f) {
    final $$MesuresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mesures,
        getReferencedColumn: (t) => t.ficheId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MesuresTableFilterComposer(
              $db: $db,
              $table: $db.mesures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FichesMesuresTableOrderingComposer
    extends Composer<_$AppDatabase, $FichesMesuresTable> {
  $$FichesMesuresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get libelle => $composableBuilder(
      column: $table.libelle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get datePrise => $composableBuilder(
      column: $table.datePrise, builder: (column) => ColumnOrderings(column));

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableOrderingComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FichesMesuresTableAnnotationComposer
    extends Composer<_$AppDatabase, $FichesMesuresTable> {
  $$FichesMesuresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get libelle =>
      $composableBuilder(column: $table.libelle, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get datePrise =>
      $composableBuilder(column: $table.datePrise, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableAnnotationComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> mesuresRefs<T extends Object>(
      Expression<T> Function($$MesuresTableAnnotationComposer a) f) {
    final $$MesuresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mesures,
        getReferencedColumn: (t) => t.ficheId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MesuresTableAnnotationComposer(
              $db: $db,
              $table: $db.mesures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FichesMesuresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FichesMesuresTable,
    FichesMesure,
    $$FichesMesuresTableFilterComposer,
    $$FichesMesuresTableOrderingComposer,
    $$FichesMesuresTableAnnotationComposer,
    $$FichesMesuresTableCreateCompanionBuilder,
    $$FichesMesuresTableUpdateCompanionBuilder,
    (FichesMesure, $$FichesMesuresTableReferences),
    FichesMesure,
    PrefetchHooks Function({bool clientId, bool mesuresRefs})> {
  $$FichesMesuresTableTableManager(_$AppDatabase db, $FichesMesuresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FichesMesuresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FichesMesuresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FichesMesuresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String> libelle = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<DateTime> datePrise = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FichesMesuresCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            clientId: clientId,
            libelle: libelle,
            remoteId: remoteId,
            datePrise: datePrise,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            required String clientId,
            required String libelle,
            Value<String?> remoteId = const Value.absent(),
            Value<DateTime> datePrise = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FichesMesuresCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            clientId: clientId,
            libelle: libelle,
            remoteId: remoteId,
            datePrise: datePrise,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FichesMesuresTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({clientId = false, mesuresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mesuresRefs) db.mesures],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (clientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clientId,
                    referencedTable:
                        $$FichesMesuresTableReferences._clientIdTable(db),
                    referencedColumn:
                        $$FichesMesuresTableReferences._clientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mesuresRefs)
                    await $_getPrefetchedData<FichesMesure, $FichesMesuresTable,
                            Mesure>(
                        currentTable: table,
                        referencedTable: $$FichesMesuresTableReferences
                            ._mesuresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FichesMesuresTableReferences(db, table, p0)
                                .mesuresRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.ficheId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$FichesMesuresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FichesMesuresTable,
    FichesMesure,
    $$FichesMesuresTableFilterComposer,
    $$FichesMesuresTableOrderingComposer,
    $$FichesMesuresTableAnnotationComposer,
    $$FichesMesuresTableCreateCompanionBuilder,
    $$FichesMesuresTableUpdateCompanionBuilder,
    (FichesMesure, $$FichesMesuresTableReferences),
    FichesMesure,
    PrefetchHooks Function({bool clientId, bool mesuresRefs})>;
typedef $$MesuresTableCreateCompanionBuilder = MesuresCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  required String ficheId,
  required String nomMesure,
  required double valeur,
  Value<String> unite,
  Value<int> ordre,
  Value<int> rowid,
});
typedef $$MesuresTableUpdateCompanionBuilder = MesuresCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  Value<String> ficheId,
  Value<String> nomMesure,
  Value<double> valeur,
  Value<String> unite,
  Value<int> ordre,
  Value<int> rowid,
});

final class $$MesuresTableReferences
    extends BaseReferences<_$AppDatabase, $MesuresTable, Mesure> {
  $$MesuresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FichesMesuresTable _ficheIdTable(_$AppDatabase db) =>
      db.fichesMesures.createAlias(
          $_aliasNameGenerator(db.mesures.ficheId, db.fichesMesures.id));

  $$FichesMesuresTableProcessedTableManager get ficheId {
    final $_column = $_itemColumn<String>('fiche_id')!;

    final manager = $$FichesMesuresTableTableManager($_db, $_db.fichesMesures)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ficheIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MesuresTableFilterComposer
    extends Composer<_$AppDatabase, $MesuresTable> {
  $$MesuresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomMesure => $composableBuilder(
      column: $table.nomMesure, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valeur => $composableBuilder(
      column: $table.valeur, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unite => $composableBuilder(
      column: $table.unite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ordre => $composableBuilder(
      column: $table.ordre, builder: (column) => ColumnFilters(column));

  $$FichesMesuresTableFilterComposer get ficheId {
    final $$FichesMesuresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ficheId,
        referencedTable: $db.fichesMesures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FichesMesuresTableFilterComposer(
              $db: $db,
              $table: $db.fichesMesures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MesuresTableOrderingComposer
    extends Composer<_$AppDatabase, $MesuresTable> {
  $$MesuresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomMesure => $composableBuilder(
      column: $table.nomMesure, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valeur => $composableBuilder(
      column: $table.valeur, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unite => $composableBuilder(
      column: $table.unite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ordre => $composableBuilder(
      column: $table.ordre, builder: (column) => ColumnOrderings(column));

  $$FichesMesuresTableOrderingComposer get ficheId {
    final $$FichesMesuresTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ficheId,
        referencedTable: $db.fichesMesures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FichesMesuresTableOrderingComposer(
              $db: $db,
              $table: $db.fichesMesures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MesuresTableAnnotationComposer
    extends Composer<_$AppDatabase, $MesuresTable> {
  $$MesuresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get nomMesure =>
      $composableBuilder(column: $table.nomMesure, builder: (column) => column);

  GeneratedColumn<double> get valeur =>
      $composableBuilder(column: $table.valeur, builder: (column) => column);

  GeneratedColumn<String> get unite =>
      $composableBuilder(column: $table.unite, builder: (column) => column);

  GeneratedColumn<int> get ordre =>
      $composableBuilder(column: $table.ordre, builder: (column) => column);

  $$FichesMesuresTableAnnotationComposer get ficheId {
    final $$FichesMesuresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ficheId,
        referencedTable: $db.fichesMesures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FichesMesuresTableAnnotationComposer(
              $db: $db,
              $table: $db.fichesMesures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MesuresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MesuresTable,
    Mesure,
    $$MesuresTableFilterComposer,
    $$MesuresTableOrderingComposer,
    $$MesuresTableAnnotationComposer,
    $$MesuresTableCreateCompanionBuilder,
    $$MesuresTableUpdateCompanionBuilder,
    (Mesure, $$MesuresTableReferences),
    Mesure,
    PrefetchHooks Function({bool ficheId})> {
  $$MesuresTableTableManager(_$AppDatabase db, $MesuresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MesuresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MesuresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MesuresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String> ficheId = const Value.absent(),
            Value<String> nomMesure = const Value.absent(),
            Value<double> valeur = const Value.absent(),
            Value<String> unite = const Value.absent(),
            Value<int> ordre = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MesuresCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            ficheId: ficheId,
            nomMesure: nomMesure,
            valeur: valeur,
            unite: unite,
            ordre: ordre,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            required String ficheId,
            required String nomMesure,
            required double valeur,
            Value<String> unite = const Value.absent(),
            Value<int> ordre = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MesuresCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            ficheId: ficheId,
            nomMesure: nomMesure,
            valeur: valeur,
            unite: unite,
            ordre: ordre,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MesuresTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({ficheId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (ficheId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ficheId,
                    referencedTable: $$MesuresTableReferences._ficheIdTable(db),
                    referencedColumn:
                        $$MesuresTableReferences._ficheIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MesuresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MesuresTable,
    Mesure,
    $$MesuresTableFilterComposer,
    $$MesuresTableOrderingComposer,
    $$MesuresTableAnnotationComposer,
    $$MesuresTableCreateCompanionBuilder,
    $$MesuresTableUpdateCompanionBuilder,
    (Mesure, $$MesuresTableReferences),
    Mesure,
    PrefetchHooks Function({bool ficheId})>;
typedef $$ModelesTableCreateCompanionBuilder = ModelesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  required String nom,
  Value<String?> description,
  Value<int?> prixIndicatif,
  Value<String?> typeVetement,
  Value<String?> imageUrl,
  Value<bool> estPublie,
  Value<String?> remoteId,
  Value<int> rowid,
});
typedef $$ModelesTableUpdateCompanionBuilder = ModelesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  Value<String> nom,
  Value<String?> description,
  Value<int?> prixIndicatif,
  Value<String?> typeVetement,
  Value<String?> imageUrl,
  Value<bool> estPublie,
  Value<String?> remoteId,
  Value<int> rowid,
});

final class $$ModelesTableReferences
    extends BaseReferences<_$AppDatabase, $ModelesTable, Modele> {
  $$ModelesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CommandesTable, List<Commande>>
      _commandesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.commandes,
              aliasName:
                  $_aliasNameGenerator(db.modeles.id, db.commandes.modeleId));

  $$CommandesTableProcessedTableManager get commandesRefs {
    final manager = $$CommandesTableTableManager($_db, $_db.commandes)
        .filter((f) => f.modeleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_commandesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ModelesTableFilterComposer
    extends Composer<_$AppDatabase, $ModelesTable> {
  $$ModelesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get prixIndicatif => $composableBuilder(
      column: $table.prixIndicatif, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typeVetement => $composableBuilder(
      column: $table.typeVetement, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get estPublie => $composableBuilder(
      column: $table.estPublie, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  Expression<bool> commandesRefs(
      Expression<bool> Function($$CommandesTableFilterComposer f) f) {
    final $$CommandesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.commandes,
        getReferencedColumn: (t) => t.modeleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CommandesTableFilterComposer(
              $db: $db,
              $table: $db.commandes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ModelesTableOrderingComposer
    extends Composer<_$AppDatabase, $ModelesTable> {
  $$ModelesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get prixIndicatif => $composableBuilder(
      column: $table.prixIndicatif,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typeVetement => $composableBuilder(
      column: $table.typeVetement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get estPublie => $composableBuilder(
      column: $table.estPublie, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));
}

class $$ModelesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModelesTable> {
  $$ModelesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get prixIndicatif => $composableBuilder(
      column: $table.prixIndicatif, builder: (column) => column);

  GeneratedColumn<String> get typeVetement => $composableBuilder(
      column: $table.typeVetement, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get estPublie =>
      $composableBuilder(column: $table.estPublie, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  Expression<T> commandesRefs<T extends Object>(
      Expression<T> Function($$CommandesTableAnnotationComposer a) f) {
    final $$CommandesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.commandes,
        getReferencedColumn: (t) => t.modeleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CommandesTableAnnotationComposer(
              $db: $db,
              $table: $db.commandes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ModelesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ModelesTable,
    Modele,
    $$ModelesTableFilterComposer,
    $$ModelesTableOrderingComposer,
    $$ModelesTableAnnotationComposer,
    $$ModelesTableCreateCompanionBuilder,
    $$ModelesTableUpdateCompanionBuilder,
    (Modele, $$ModelesTableReferences),
    Modele,
    PrefetchHooks Function({bool commandesRefs})> {
  $$ModelesTableTableManager(_$AppDatabase db, $ModelesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int?> prixIndicatif = const Value.absent(),
            Value<String?> typeVetement = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<bool> estPublie = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModelesCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            nom: nom,
            description: description,
            prixIndicatif: prixIndicatif,
            typeVetement: typeVetement,
            imageUrl: imageUrl,
            estPublie: estPublie,
            remoteId: remoteId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            required String nom,
            Value<String?> description = const Value.absent(),
            Value<int?> prixIndicatif = const Value.absent(),
            Value<String?> typeVetement = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<bool> estPublie = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModelesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            nom: nom,
            description: description,
            prixIndicatif: prixIndicatif,
            typeVetement: typeVetement,
            imageUrl: imageUrl,
            estPublie: estPublie,
            remoteId: remoteId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ModelesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({commandesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (commandesRefs) db.commandes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (commandesRefs)
                    await $_getPrefetchedData<Modele, $ModelesTable, Commande>(
                        currentTable: table,
                        referencedTable:
                            $$ModelesTableReferences._commandesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ModelesTableReferences(db, table, p0)
                                .commandesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.modeleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ModelesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ModelesTable,
    Modele,
    $$ModelesTableFilterComposer,
    $$ModelesTableOrderingComposer,
    $$ModelesTableAnnotationComposer,
    $$ModelesTableCreateCompanionBuilder,
    $$ModelesTableUpdateCompanionBuilder,
    (Modele, $$ModelesTableReferences),
    Modele,
    PrefetchHooks Function({bool commandesRefs})>;
typedef $$CommandesTableCreateCompanionBuilder = CommandesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  required String clientId,
  Value<String?> modeleId,
  Value<String?> description,
  Value<String?> notes,
  required int prixConvenu,
  Value<DateTime> dateCommande,
  required DateTime dateEcheance,
  Value<StatutCommande> statut,
  Value<String?> remoteId,
  Value<String?> statutDistant,
  Value<String?> reference,
  Value<int> rowid,
});
typedef $$CommandesTableUpdateCompanionBuilder = CommandesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  Value<String> clientId,
  Value<String?> modeleId,
  Value<String?> description,
  Value<String?> notes,
  Value<int> prixConvenu,
  Value<DateTime> dateCommande,
  Value<DateTime> dateEcheance,
  Value<StatutCommande> statut,
  Value<String?> remoteId,
  Value<String?> statutDistant,
  Value<String?> reference,
  Value<int> rowid,
});

final class $$CommandesTableReferences
    extends BaseReferences<_$AppDatabase, $CommandesTable, Commande> {
  $$CommandesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) => db.clients
      .createAlias($_aliasNameGenerator(db.commandes.clientId, db.clients.id));

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<String>('client_id')!;

    final manager = $$ClientsTableTableManager($_db, $_db.clients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ModelesTable _modeleIdTable(_$AppDatabase db) => db.modeles
      .createAlias($_aliasNameGenerator(db.commandes.modeleId, db.modeles.id));

  $$ModelesTableProcessedTableManager? get modeleId {
    final $_column = $_itemColumn<String>('modele_id');
    if ($_column == null) return null;
    final manager = $$ModelesTableTableManager($_db, $_db.modeles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modeleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PaiementsTable, List<Paiement>>
      _paiementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.paiements,
          aliasName:
              $_aliasNameGenerator(db.commandes.id, db.paiements.commandeId));

  $$PaiementsTableProcessedTableManager get paiementsRefs {
    final manager = $$PaiementsTableTableManager($_db, $_db.paiements)
        .filter((f) => f.commandeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paiementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CommandesTableFilterComposer
    extends Composer<_$AppDatabase, $CommandesTable> {
  $$CommandesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get prixConvenu => $composableBuilder(
      column: $table.prixConvenu, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateCommande => $composableBuilder(
      column: $table.dateCommande, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateEcheance => $composableBuilder(
      column: $table.dateEcheance, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<StatutCommande, StatutCommande, String>
      get statut => $composableBuilder(
          column: $table.statut,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statutDistant => $composableBuilder(
      column: $table.statutDistant, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableFilterComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ModelesTableFilterComposer get modeleId {
    final $$ModelesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeleId,
        referencedTable: $db.modeles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelesTableFilterComposer(
              $db: $db,
              $table: $db.modeles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> paiementsRefs(
      Expression<bool> Function($$PaiementsTableFilterComposer f) f) {
    final $$PaiementsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.paiements,
        getReferencedColumn: (t) => t.commandeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaiementsTableFilterComposer(
              $db: $db,
              $table: $db.paiements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CommandesTableOrderingComposer
    extends Composer<_$AppDatabase, $CommandesTable> {
  $$CommandesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get prixConvenu => $composableBuilder(
      column: $table.prixConvenu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateCommande => $composableBuilder(
      column: $table.dateCommande,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateEcheance => $composableBuilder(
      column: $table.dateEcheance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statutDistant => $composableBuilder(
      column: $table.statutDistant,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableOrderingComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ModelesTableOrderingComposer get modeleId {
    final $$ModelesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeleId,
        referencedTable: $db.modeles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelesTableOrderingComposer(
              $db: $db,
              $table: $db.modeles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CommandesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommandesTable> {
  $$CommandesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get prixConvenu => $composableBuilder(
      column: $table.prixConvenu, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCommande => $composableBuilder(
      column: $table.dateCommande, builder: (column) => column);

  GeneratedColumn<DateTime> get dateEcheance => $composableBuilder(
      column: $table.dateEcheance, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StatutCommande, String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get statutDistant => $composableBuilder(
      column: $table.statutDistant, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableAnnotationComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ModelesTableAnnotationComposer get modeleId {
    final $$ModelesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeleId,
        referencedTable: $db.modeles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelesTableAnnotationComposer(
              $db: $db,
              $table: $db.modeles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> paiementsRefs<T extends Object>(
      Expression<T> Function($$PaiementsTableAnnotationComposer a) f) {
    final $$PaiementsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.paiements,
        getReferencedColumn: (t) => t.commandeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaiementsTableAnnotationComposer(
              $db: $db,
              $table: $db.paiements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CommandesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CommandesTable,
    Commande,
    $$CommandesTableFilterComposer,
    $$CommandesTableOrderingComposer,
    $$CommandesTableAnnotationComposer,
    $$CommandesTableCreateCompanionBuilder,
    $$CommandesTableUpdateCompanionBuilder,
    (Commande, $$CommandesTableReferences),
    Commande,
    PrefetchHooks Function(
        {bool clientId, bool modeleId, bool paiementsRefs})> {
  $$CommandesTableTableManager(_$AppDatabase db, $CommandesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommandesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommandesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommandesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> modeleId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> prixConvenu = const Value.absent(),
            Value<DateTime> dateCommande = const Value.absent(),
            Value<DateTime> dateEcheance = const Value.absent(),
            Value<StatutCommande> statut = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<String?> statutDistant = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CommandesCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            clientId: clientId,
            modeleId: modeleId,
            description: description,
            notes: notes,
            prixConvenu: prixConvenu,
            dateCommande: dateCommande,
            dateEcheance: dateEcheance,
            statut: statut,
            remoteId: remoteId,
            statutDistant: statutDistant,
            reference: reference,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            required String clientId,
            Value<String?> modeleId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required int prixConvenu,
            Value<DateTime> dateCommande = const Value.absent(),
            required DateTime dateEcheance,
            Value<StatutCommande> statut = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<String?> statutDistant = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CommandesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            clientId: clientId,
            modeleId: modeleId,
            description: description,
            notes: notes,
            prixConvenu: prixConvenu,
            dateCommande: dateCommande,
            dateEcheance: dateEcheance,
            statut: statut,
            remoteId: remoteId,
            statutDistant: statutDistant,
            reference: reference,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CommandesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {clientId = false, modeleId = false, paiementsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (paiementsRefs) db.paiements],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (clientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clientId,
                    referencedTable:
                        $$CommandesTableReferences._clientIdTable(db),
                    referencedColumn:
                        $$CommandesTableReferences._clientIdTable(db).id,
                  ) as T;
                }
                if (modeleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.modeleId,
                    referencedTable:
                        $$CommandesTableReferences._modeleIdTable(db),
                    referencedColumn:
                        $$CommandesTableReferences._modeleIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paiementsRefs)
                    await $_getPrefetchedData<Commande, $CommandesTable,
                            Paiement>(
                        currentTable: table,
                        referencedTable:
                            $$CommandesTableReferences._paiementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CommandesTableReferences(db, table, p0)
                                .paiementsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.commandeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CommandesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CommandesTable,
    Commande,
    $$CommandesTableFilterComposer,
    $$CommandesTableOrderingComposer,
    $$CommandesTableAnnotationComposer,
    $$CommandesTableCreateCompanionBuilder,
    $$CommandesTableUpdateCompanionBuilder,
    (Commande, $$CommandesTableReferences),
    Commande,
    PrefetchHooks Function({bool clientId, bool modeleId, bool paiementsRefs})>;
typedef $$PaiementsTableCreateCompanionBuilder = PaiementsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  required String commandeId,
  required int montant,
  Value<DateTime> datePaiement,
  Value<ModePaiement> mode,
  Value<String?> note,
  Value<String> statut,
  Value<String?> reference,
  Value<String?> remoteId,
  Value<String?> statutDistant,
  Value<String?> numeroRecu,
  Value<int> rowid,
});
typedef $$PaiementsTableUpdateCompanionBuilder = PaiementsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isSynced,
  Value<String> commandeId,
  Value<int> montant,
  Value<DateTime> datePaiement,
  Value<ModePaiement> mode,
  Value<String?> note,
  Value<String> statut,
  Value<String?> reference,
  Value<String?> remoteId,
  Value<String?> statutDistant,
  Value<String?> numeroRecu,
  Value<int> rowid,
});

final class $$PaiementsTableReferences
    extends BaseReferences<_$AppDatabase, $PaiementsTable, Paiement> {
  $$PaiementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CommandesTable _commandeIdTable(_$AppDatabase db) =>
      db.commandes.createAlias(
          $_aliasNameGenerator(db.paiements.commandeId, db.commandes.id));

  $$CommandesTableProcessedTableManager get commandeId {
    final $_column = $_itemColumn<String>('commande_id')!;

    final manager = $$CommandesTableTableManager($_db, $_db.commandes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_commandeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PaiementsTableFilterComposer
    extends Composer<_$AppDatabase, $PaiementsTable> {
  $$PaiementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get montant => $composableBuilder(
      column: $table.montant, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ModePaiement, ModePaiement, String> get mode =>
      $composableBuilder(
          column: $table.mode,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statutDistant => $composableBuilder(
      column: $table.statutDistant, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numeroRecu => $composableBuilder(
      column: $table.numeroRecu, builder: (column) => ColumnFilters(column));

  $$CommandesTableFilterComposer get commandeId {
    final $$CommandesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.commandeId,
        referencedTable: $db.commandes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CommandesTableFilterComposer(
              $db: $db,
              $table: $db.commandes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaiementsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaiementsTable> {
  $$PaiementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get montant => $composableBuilder(
      column: $table.montant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statutDistant => $composableBuilder(
      column: $table.statutDistant,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numeroRecu => $composableBuilder(
      column: $table.numeroRecu, builder: (column) => ColumnOrderings(column));

  $$CommandesTableOrderingComposer get commandeId {
    final $$CommandesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.commandeId,
        referencedTable: $db.commandes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CommandesTableOrderingComposer(
              $db: $db,
              $table: $db.commandes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaiementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaiementsTable> {
  $$PaiementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<int> get montant =>
      $composableBuilder(column: $table.montant, builder: (column) => column);

  GeneratedColumn<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ModePaiement, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get statutDistant => $composableBuilder(
      column: $table.statutDistant, builder: (column) => column);

  GeneratedColumn<String> get numeroRecu => $composableBuilder(
      column: $table.numeroRecu, builder: (column) => column);

  $$CommandesTableAnnotationComposer get commandeId {
    final $$CommandesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.commandeId,
        referencedTable: $db.commandes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CommandesTableAnnotationComposer(
              $db: $db,
              $table: $db.commandes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaiementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaiementsTable,
    Paiement,
    $$PaiementsTableFilterComposer,
    $$PaiementsTableOrderingComposer,
    $$PaiementsTableAnnotationComposer,
    $$PaiementsTableCreateCompanionBuilder,
    $$PaiementsTableUpdateCompanionBuilder,
    (Paiement, $$PaiementsTableReferences),
    Paiement,
    PrefetchHooks Function({bool commandeId})> {
  $$PaiementsTableTableManager(_$AppDatabase db, $PaiementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaiementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaiementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaiementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String> commandeId = const Value.absent(),
            Value<int> montant = const Value.absent(),
            Value<DateTime> datePaiement = const Value.absent(),
            Value<ModePaiement> mode = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<String?> statutDistant = const Value.absent(),
            Value<String?> numeroRecu = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaiementsCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            commandeId: commandeId,
            montant: montant,
            datePaiement: datePaiement,
            mode: mode,
            note: note,
            statut: statut,
            reference: reference,
            remoteId: remoteId,
            statutDistant: statutDistant,
            numeroRecu: numeroRecu,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            required String commandeId,
            required int montant,
            Value<DateTime> datePaiement = const Value.absent(),
            Value<ModePaiement> mode = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<String?> statutDistant = const Value.absent(),
            Value<String?> numeroRecu = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaiementsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            isSynced: isSynced,
            commandeId: commandeId,
            montant: montant,
            datePaiement: datePaiement,
            mode: mode,
            note: note,
            statut: statut,
            reference: reference,
            remoteId: remoteId,
            statutDistant: statutDistant,
            numeroRecu: numeroRecu,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PaiementsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({commandeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (commandeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.commandeId,
                    referencedTable:
                        $$PaiementsTableReferences._commandeIdTable(db),
                    referencedColumn:
                        $$PaiementsTableReferences._commandeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PaiementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaiementsTable,
    Paiement,
    $$PaiementsTableFilterComposer,
    $$PaiementsTableOrderingComposer,
    $$PaiementsTableAnnotationComposer,
    $$PaiementsTableCreateCompanionBuilder,
    $$PaiementsTableUpdateCompanionBuilder,
    (Paiement, $$PaiementsTableReferences),
    Paiement,
    PrefetchHooks Function({bool commandeId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SalonsTableTableManager get salons =>
      $$SalonsTableTableManager(_db, _db.salons);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$FichesMesuresTableTableManager get fichesMesures =>
      $$FichesMesuresTableTableManager(_db, _db.fichesMesures);
  $$MesuresTableTableManager get mesures =>
      $$MesuresTableTableManager(_db, _db.mesures);
  $$ModelesTableTableManager get modeles =>
      $$ModelesTableTableManager(_db, _db.modeles);
  $$CommandesTableTableManager get commandes =>
      $$CommandesTableTableManager(_db, _db.commandes);
  $$PaiementsTableTableManager get paiements =>
      $$PaiementsTableTableManager(_db, _db.paiements);
}
