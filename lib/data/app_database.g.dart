// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: genUuidV7,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const User({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
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
      version: Value(version),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
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
      'version': serializer.toJson<int>(version),
    };
  }

  User copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => User(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, deletedAt, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
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
    if (version.present) {
      map['version'] = Variable<int>(version.value);
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
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PerUserTargetsTable extends PerUserTargets
    with TableInfo<$PerUserTargetsTable, PerUserTarget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerUserTargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: genUuidV7,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _calorieTargetMeta = const VerificationMeta(
    'calorieTarget',
  );
  @override
  late final GeneratedColumn<int> calorieTarget = GeneratedColumn<int>(
    'calorie_target',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinTargetMeta = const VerificationMeta(
    'proteinTarget',
  );
  @override
  late final GeneratedColumn<double> proteinTarget = GeneratedColumn<double>(
    'protein_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fiberTargetMeta = const VerificationMeta(
    'fiberTarget',
  );
  @override
  late final GeneratedColumn<double> fiberTarget = GeneratedColumn<double>(
    'fiber_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fruitCupsTargetMeta = const VerificationMeta(
    'fruitCupsTarget',
  );
  @override
  late final GeneratedColumn<double> fruitCupsTarget = GeneratedColumn<double>(
    'fruit_cups_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _veggieCupsTargetMeta = const VerificationMeta(
    'veggieCupsTarget',
  );
  @override
  late final GeneratedColumn<double> veggieCupsTarget = GeneratedColumn<double>(
    'veggie_cups_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedSugarLimitMeta = const VerificationMeta(
    'addedSugarLimit',
  );
  @override
  late final GeneratedColumn<double> addedSugarLimit = GeneratedColumn<double>(
    'added_sugar_limit',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbsLimitGMeta = const VerificationMeta(
    'carbsLimitG',
  );
  @override
  late final GeneratedColumn<double> carbsLimitG = GeneratedColumn<double>(
    'carbs_limit_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatsLimitGMeta = const VerificationMeta(
    'fatsLimitG',
  );
  @override
  late final GeneratedColumn<double> fatsLimitG = GeneratedColumn<double>(
    'fats_limit_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waterTargetMeta = const VerificationMeta(
    'waterTarget',
  );
  @override
  late final GeneratedColumn<double> waterTarget = GeneratedColumn<double>(
    'water_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightTargetMeta = const VerificationMeta(
    'weightTarget',
  );
  @override
  late final GeneratedColumn<double> weightTarget = GeneratedColumn<double>(
    'weight_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    calorieTarget,
    proteinTarget,
    fiberTarget,
    fruitCupsTarget,
    veggieCupsTarget,
    addedSugarLimit,
    carbsLimitG,
    fatsLimitG,
    waterTarget,
    weightTarget,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'per_user_targets';
  @override
  VerificationContext validateIntegrity(
    Insertable<PerUserTarget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('calorie_target')) {
      context.handle(
        _calorieTargetMeta,
        calorieTarget.isAcceptableOrUnknown(
          data['calorie_target']!,
          _calorieTargetMeta,
        ),
      );
    }
    if (data.containsKey('protein_target')) {
      context.handle(
        _proteinTargetMeta,
        proteinTarget.isAcceptableOrUnknown(
          data['protein_target']!,
          _proteinTargetMeta,
        ),
      );
    }
    if (data.containsKey('fiber_target')) {
      context.handle(
        _fiberTargetMeta,
        fiberTarget.isAcceptableOrUnknown(
          data['fiber_target']!,
          _fiberTargetMeta,
        ),
      );
    }
    if (data.containsKey('fruit_cups_target')) {
      context.handle(
        _fruitCupsTargetMeta,
        fruitCupsTarget.isAcceptableOrUnknown(
          data['fruit_cups_target']!,
          _fruitCupsTargetMeta,
        ),
      );
    }
    if (data.containsKey('veggie_cups_target')) {
      context.handle(
        _veggieCupsTargetMeta,
        veggieCupsTarget.isAcceptableOrUnknown(
          data['veggie_cups_target']!,
          _veggieCupsTargetMeta,
        ),
      );
    }
    if (data.containsKey('added_sugar_limit')) {
      context.handle(
        _addedSugarLimitMeta,
        addedSugarLimit.isAcceptableOrUnknown(
          data['added_sugar_limit']!,
          _addedSugarLimitMeta,
        ),
      );
    }
    if (data.containsKey('carbs_limit_g')) {
      context.handle(
        _carbsLimitGMeta,
        carbsLimitG.isAcceptableOrUnknown(
          data['carbs_limit_g']!,
          _carbsLimitGMeta,
        ),
      );
    }
    if (data.containsKey('fats_limit_g')) {
      context.handle(
        _fatsLimitGMeta,
        fatsLimitG.isAcceptableOrUnknown(
          data['fats_limit_g']!,
          _fatsLimitGMeta,
        ),
      );
    }
    if (data.containsKey('water_target')) {
      context.handle(
        _waterTargetMeta,
        waterTarget.isAcceptableOrUnknown(
          data['water_target']!,
          _waterTargetMeta,
        ),
      );
    }
    if (data.containsKey('weight_target')) {
      context.handle(
        _weightTargetMeta,
        weightTarget.isAcceptableOrUnknown(
          data['weight_target']!,
          _weightTargetMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PerUserTarget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerUserTarget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      calorieTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calorie_target'],
      ),
      proteinTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_target'],
      ),
      fiberTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_target'],
      ),
      fruitCupsTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fruit_cups_target'],
      ),
      veggieCupsTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}veggie_cups_target'],
      ),
      addedSugarLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}added_sugar_limit'],
      ),
      carbsLimitG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_limit_g'],
      ),
      fatsLimitG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fats_limit_g'],
      ),
      waterTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}water_target'],
      ),
      weightTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_target'],
      ),
    );
  }

  @override
  $PerUserTargetsTable createAlias(String alias) {
    return $PerUserTargetsTable(attachedDatabase, alias);
  }
}

class PerUserTarget extends DataClass implements Insertable<PerUserTarget> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final DateTime? deletedAt;
  final int version;
  final int? calorieTarget;
  final double? proteinTarget;
  final double? fiberTarget;
  final double? fruitCupsTarget;
  final double? veggieCupsTarget;
  final double? addedSugarLimit;
  final double? carbsLimitG;
  final double? fatsLimitG;
  final double? waterTarget;
  final double? weightTarget;
  const PerUserTarget({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.deletedAt,
    required this.version,
    this.calorieTarget,
    this.proteinTarget,
    this.fiberTarget,
    this.fruitCupsTarget,
    this.veggieCupsTarget,
    this.addedSugarLimit,
    this.carbsLimitG,
    this.fatsLimitG,
    this.waterTarget,
    this.weightTarget,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || calorieTarget != null) {
      map['calorie_target'] = Variable<int>(calorieTarget);
    }
    if (!nullToAbsent || proteinTarget != null) {
      map['protein_target'] = Variable<double>(proteinTarget);
    }
    if (!nullToAbsent || fiberTarget != null) {
      map['fiber_target'] = Variable<double>(fiberTarget);
    }
    if (!nullToAbsent || fruitCupsTarget != null) {
      map['fruit_cups_target'] = Variable<double>(fruitCupsTarget);
    }
    if (!nullToAbsent || veggieCupsTarget != null) {
      map['veggie_cups_target'] = Variable<double>(veggieCupsTarget);
    }
    if (!nullToAbsent || addedSugarLimit != null) {
      map['added_sugar_limit'] = Variable<double>(addedSugarLimit);
    }
    if (!nullToAbsent || carbsLimitG != null) {
      map['carbs_limit_g'] = Variable<double>(carbsLimitG);
    }
    if (!nullToAbsent || fatsLimitG != null) {
      map['fats_limit_g'] = Variable<double>(fatsLimitG);
    }
    if (!nullToAbsent || waterTarget != null) {
      map['water_target'] = Variable<double>(waterTarget);
    }
    if (!nullToAbsent || weightTarget != null) {
      map['weight_target'] = Variable<double>(weightTarget);
    }
    return map;
  }

  PerUserTargetsCompanion toCompanion(bool nullToAbsent) {
    return PerUserTargetsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      userId: Value(userId),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
      calorieTarget: calorieTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(calorieTarget),
      proteinTarget: proteinTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinTarget),
      fiberTarget: fiberTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(fiberTarget),
      fruitCupsTarget: fruitCupsTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(fruitCupsTarget),
      veggieCupsTarget: veggieCupsTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(veggieCupsTarget),
      addedSugarLimit: addedSugarLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(addedSugarLimit),
      carbsLimitG: carbsLimitG == null && nullToAbsent
          ? const Value.absent()
          : Value(carbsLimitG),
      fatsLimitG: fatsLimitG == null && nullToAbsent
          ? const Value.absent()
          : Value(fatsLimitG),
      waterTarget: waterTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(waterTarget),
      weightTarget: weightTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(weightTarget),
    );
  }

  factory PerUserTarget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerUserTarget(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userId: serializer.fromJson<String>(json['userId']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
      calorieTarget: serializer.fromJson<int?>(json['calorieTarget']),
      proteinTarget: serializer.fromJson<double?>(json['proteinTarget']),
      fiberTarget: serializer.fromJson<double?>(json['fiberTarget']),
      fruitCupsTarget: serializer.fromJson<double?>(json['fruitCupsTarget']),
      veggieCupsTarget: serializer.fromJson<double?>(json['veggieCupsTarget']),
      addedSugarLimit: serializer.fromJson<double?>(json['addedSugarLimit']),
      carbsLimitG: serializer.fromJson<double?>(json['carbsLimitG']),
      fatsLimitG: serializer.fromJson<double?>(json['fatsLimitG']),
      waterTarget: serializer.fromJson<double?>(json['waterTarget']),
      weightTarget: serializer.fromJson<double?>(json['weightTarget']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userId': serializer.toJson<String>(userId),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
      'calorieTarget': serializer.toJson<int?>(calorieTarget),
      'proteinTarget': serializer.toJson<double?>(proteinTarget),
      'fiberTarget': serializer.toJson<double?>(fiberTarget),
      'fruitCupsTarget': serializer.toJson<double?>(fruitCupsTarget),
      'veggieCupsTarget': serializer.toJson<double?>(veggieCupsTarget),
      'addedSugarLimit': serializer.toJson<double?>(addedSugarLimit),
      'carbsLimitG': serializer.toJson<double?>(carbsLimitG),
      'fatsLimitG': serializer.toJson<double?>(fatsLimitG),
      'waterTarget': serializer.toJson<double?>(waterTarget),
      'weightTarget': serializer.toJson<double?>(weightTarget),
    };
  }

  PerUserTarget copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
    Value<int?> calorieTarget = const Value.absent(),
    Value<double?> proteinTarget = const Value.absent(),
    Value<double?> fiberTarget = const Value.absent(),
    Value<double?> fruitCupsTarget = const Value.absent(),
    Value<double?> veggieCupsTarget = const Value.absent(),
    Value<double?> addedSugarLimit = const Value.absent(),
    Value<double?> carbsLimitG = const Value.absent(),
    Value<double?> fatsLimitG = const Value.absent(),
    Value<double?> waterTarget = const Value.absent(),
    Value<double?> weightTarget = const Value.absent(),
  }) => PerUserTarget(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userId: userId ?? this.userId,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
    calorieTarget: calorieTarget.present
        ? calorieTarget.value
        : this.calorieTarget,
    proteinTarget: proteinTarget.present
        ? proteinTarget.value
        : this.proteinTarget,
    fiberTarget: fiberTarget.present ? fiberTarget.value : this.fiberTarget,
    fruitCupsTarget: fruitCupsTarget.present
        ? fruitCupsTarget.value
        : this.fruitCupsTarget,
    veggieCupsTarget: veggieCupsTarget.present
        ? veggieCupsTarget.value
        : this.veggieCupsTarget,
    addedSugarLimit: addedSugarLimit.present
        ? addedSugarLimit.value
        : this.addedSugarLimit,
    carbsLimitG: carbsLimitG.present ? carbsLimitG.value : this.carbsLimitG,
    fatsLimitG: fatsLimitG.present ? fatsLimitG.value : this.fatsLimitG,
    waterTarget: waterTarget.present ? waterTarget.value : this.waterTarget,
    weightTarget: weightTarget.present ? weightTarget.value : this.weightTarget,
  );
  PerUserTarget copyWithCompanion(PerUserTargetsCompanion data) {
    return PerUserTarget(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
      calorieTarget: data.calorieTarget.present
          ? data.calorieTarget.value
          : this.calorieTarget,
      proteinTarget: data.proteinTarget.present
          ? data.proteinTarget.value
          : this.proteinTarget,
      fiberTarget: data.fiberTarget.present
          ? data.fiberTarget.value
          : this.fiberTarget,
      fruitCupsTarget: data.fruitCupsTarget.present
          ? data.fruitCupsTarget.value
          : this.fruitCupsTarget,
      veggieCupsTarget: data.veggieCupsTarget.present
          ? data.veggieCupsTarget.value
          : this.veggieCupsTarget,
      addedSugarLimit: data.addedSugarLimit.present
          ? data.addedSugarLimit.value
          : this.addedSugarLimit,
      carbsLimitG: data.carbsLimitG.present
          ? data.carbsLimitG.value
          : this.carbsLimitG,
      fatsLimitG: data.fatsLimitG.present
          ? data.fatsLimitG.value
          : this.fatsLimitG,
      waterTarget: data.waterTarget.present
          ? data.waterTarget.value
          : this.waterTarget,
      weightTarget: data.weightTarget.present
          ? data.weightTarget.value
          : this.weightTarget,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerUserTarget(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTarget: $proteinTarget, ')
          ..write('fiberTarget: $fiberTarget, ')
          ..write('fruitCupsTarget: $fruitCupsTarget, ')
          ..write('veggieCupsTarget: $veggieCupsTarget, ')
          ..write('addedSugarLimit: $addedSugarLimit, ')
          ..write('carbsLimitG: $carbsLimitG, ')
          ..write('fatsLimitG: $fatsLimitG, ')
          ..write('waterTarget: $waterTarget, ')
          ..write('weightTarget: $weightTarget')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    calorieTarget,
    proteinTarget,
    fiberTarget,
    fruitCupsTarget,
    veggieCupsTarget,
    addedSugarLimit,
    carbsLimitG,
    fatsLimitG,
    waterTarget,
    weightTarget,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerUserTarget &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userId == this.userId &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version &&
          other.calorieTarget == this.calorieTarget &&
          other.proteinTarget == this.proteinTarget &&
          other.fiberTarget == this.fiberTarget &&
          other.fruitCupsTarget == this.fruitCupsTarget &&
          other.veggieCupsTarget == this.veggieCupsTarget &&
          other.addedSugarLimit == this.addedSugarLimit &&
          other.carbsLimitG == this.carbsLimitG &&
          other.fatsLimitG == this.fatsLimitG &&
          other.waterTarget == this.waterTarget &&
          other.weightTarget == this.weightTarget);
}

class PerUserTargetsCompanion extends UpdateCompanion<PerUserTarget> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> userId;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int?> calorieTarget;
  final Value<double?> proteinTarget;
  final Value<double?> fiberTarget;
  final Value<double?> fruitCupsTarget;
  final Value<double?> veggieCupsTarget;
  final Value<double?> addedSugarLimit;
  final Value<double?> carbsLimitG;
  final Value<double?> fatsLimitG;
  final Value<double?> waterTarget;
  final Value<double?> weightTarget;
  final Value<int> rowid;
  const PerUserTargetsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.calorieTarget = const Value.absent(),
    this.proteinTarget = const Value.absent(),
    this.fiberTarget = const Value.absent(),
    this.fruitCupsTarget = const Value.absent(),
    this.veggieCupsTarget = const Value.absent(),
    this.addedSugarLimit = const Value.absent(),
    this.carbsLimitG = const Value.absent(),
    this.fatsLimitG = const Value.absent(),
    this.waterTarget = const Value.absent(),
    this.weightTarget = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PerUserTargetsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String userId,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.calorieTarget = const Value.absent(),
    this.proteinTarget = const Value.absent(),
    this.fiberTarget = const Value.absent(),
    this.fruitCupsTarget = const Value.absent(),
    this.veggieCupsTarget = const Value.absent(),
    this.addedSugarLimit = const Value.absent(),
    this.carbsLimitG = const Value.absent(),
    this.fatsLimitG = const Value.absent(),
    this.waterTarget = const Value.absent(),
    this.weightTarget = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<PerUserTarget> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? userId,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? calorieTarget,
    Expression<double>? proteinTarget,
    Expression<double>? fiberTarget,
    Expression<double>? fruitCupsTarget,
    Expression<double>? veggieCupsTarget,
    Expression<double>? addedSugarLimit,
    Expression<double>? carbsLimitG,
    Expression<double>? fatsLimitG,
    Expression<double>? waterTarget,
    Expression<double>? weightTarget,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (userId != null) 'user_id': userId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (calorieTarget != null) 'calorie_target': calorieTarget,
      if (proteinTarget != null) 'protein_target': proteinTarget,
      if (fiberTarget != null) 'fiber_target': fiberTarget,
      if (fruitCupsTarget != null) 'fruit_cups_target': fruitCupsTarget,
      if (veggieCupsTarget != null) 'veggie_cups_target': veggieCupsTarget,
      if (addedSugarLimit != null) 'added_sugar_limit': addedSugarLimit,
      if (carbsLimitG != null) 'carbs_limit_g': carbsLimitG,
      if (fatsLimitG != null) 'fats_limit_g': fatsLimitG,
      if (waterTarget != null) 'water_target': waterTarget,
      if (weightTarget != null) 'weight_target': weightTarget,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PerUserTargetsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? userId,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int?>? calorieTarget,
    Value<double?>? proteinTarget,
    Value<double?>? fiberTarget,
    Value<double?>? fruitCupsTarget,
    Value<double?>? veggieCupsTarget,
    Value<double?>? addedSugarLimit,
    Value<double?>? carbsLimitG,
    Value<double?>? fatsLimitG,
    Value<double?>? waterTarget,
    Value<double?>? weightTarget,
    Value<int>? rowid,
  }) {
    return PerUserTargetsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      fiberTarget: fiberTarget ?? this.fiberTarget,
      fruitCupsTarget: fruitCupsTarget ?? this.fruitCupsTarget,
      veggieCupsTarget: veggieCupsTarget ?? this.veggieCupsTarget,
      addedSugarLimit: addedSugarLimit ?? this.addedSugarLimit,
      carbsLimitG: carbsLimitG ?? this.carbsLimitG,
      fatsLimitG: fatsLimitG ?? this.fatsLimitG,
      waterTarget: waterTarget ?? this.waterTarget,
      weightTarget: weightTarget ?? this.weightTarget,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (calorieTarget.present) {
      map['calorie_target'] = Variable<int>(calorieTarget.value);
    }
    if (proteinTarget.present) {
      map['protein_target'] = Variable<double>(proteinTarget.value);
    }
    if (fiberTarget.present) {
      map['fiber_target'] = Variable<double>(fiberTarget.value);
    }
    if (fruitCupsTarget.present) {
      map['fruit_cups_target'] = Variable<double>(fruitCupsTarget.value);
    }
    if (veggieCupsTarget.present) {
      map['veggie_cups_target'] = Variable<double>(veggieCupsTarget.value);
    }
    if (addedSugarLimit.present) {
      map['added_sugar_limit'] = Variable<double>(addedSugarLimit.value);
    }
    if (carbsLimitG.present) {
      map['carbs_limit_g'] = Variable<double>(carbsLimitG.value);
    }
    if (fatsLimitG.present) {
      map['fats_limit_g'] = Variable<double>(fatsLimitG.value);
    }
    if (waterTarget.present) {
      map['water_target'] = Variable<double>(waterTarget.value);
    }
    if (weightTarget.present) {
      map['weight_target'] = Variable<double>(weightTarget.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerUserTargetsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTarget: $proteinTarget, ')
          ..write('fiberTarget: $fiberTarget, ')
          ..write('fruitCupsTarget: $fruitCupsTarget, ')
          ..write('veggieCupsTarget: $veggieCupsTarget, ')
          ..write('addedSugarLimit: $addedSugarLimit, ')
          ..write('carbsLimitG: $carbsLimitG, ')
          ..write('fatsLimitG: $fatsLimitG, ')
          ..write('waterTarget: $waterTarget, ')
          ..write('weightTarget: $weightTarget, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodEntriesTable extends FoodEntries
    with TableInfo<$FoodEntriesTable, FoodEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: genUuidV7,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _entryTimestampMeta = const VerificationMeta(
    'entryTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> entryTimestamp =
      GeneratedColumn<DateTime>(
        'entry_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FoodUnit, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FoodUnit>($FoodEntriesTable.$converterunit);
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fatsGMeta = const VerificationMeta('fatsG');
  @override
  late final GeneratedColumn<double> fatsG = GeneratedColumn<double>(
    'fats_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fiberGMeta = const VerificationMeta('fiberG');
  @override
  late final GeneratedColumn<double> fiberG = GeneratedColumn<double>(
    'fiber_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addedSugarGMeta = const VerificationMeta(
    'addedSugarG',
  );
  @override
  late final GeneratedColumn<double> addedSugarG = GeneratedColumn<double>(
    'added_sugar_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fruitCupsMeta = const VerificationMeta(
    'fruitCups',
  );
  @override
  late final GeneratedColumn<double> fruitCups = GeneratedColumn<double>(
    'fruit_cups',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _veggieCupsMeta = const VerificationMeta(
    'veggieCups',
  );
  @override
  late final GeneratedColumn<double> veggieCups = GeneratedColumn<double>(
    'veggie_cups',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MealType, String> mealType =
      GeneratedColumn<String>(
        'meal_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MealType>($FoodEntriesTable.$convertermealType);
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    entryTimestamp,
    quantity,
    unit,
    calories,
    proteinG,
    carbsG,
    fatsG,
    fiberG,
    addedSugarG,
    fruitCups,
    veggieCups,
    name,
    mealType,
    isVerified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('entry_timestamp')) {
      context.handle(
        _entryTimestampMeta,
        entryTimestamp.isAcceptableOrUnknown(
          data['entry_timestamp']!,
          _entryTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entryTimestampMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    }
    if (data.containsKey('fats_g')) {
      context.handle(
        _fatsGMeta,
        fatsG.isAcceptableOrUnknown(data['fats_g']!, _fatsGMeta),
      );
    }
    if (data.containsKey('fiber_g')) {
      context.handle(
        _fiberGMeta,
        fiberG.isAcceptableOrUnknown(data['fiber_g']!, _fiberGMeta),
      );
    }
    if (data.containsKey('added_sugar_g')) {
      context.handle(
        _addedSugarGMeta,
        addedSugarG.isAcceptableOrUnknown(
          data['added_sugar_g']!,
          _addedSugarGMeta,
        ),
      );
    }
    if (data.containsKey('fruit_cups')) {
      context.handle(
        _fruitCupsMeta,
        fruitCups.isAcceptableOrUnknown(data['fruit_cups']!, _fruitCupsMeta),
      );
    }
    if (data.containsKey('veggie_cups')) {
      context.handle(
        _veggieCupsMeta,
        veggieCups.isAcceptableOrUnknown(data['veggie_cups']!, _veggieCupsMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      entryTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_timestamp'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: $FoodEntriesTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        )!,
      ),
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      )!,
      fatsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fats_g'],
      )!,
      fiberG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_g'],
      )!,
      addedSugarG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}added_sugar_g'],
      )!,
      fruitCups: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fruit_cups'],
      )!,
      veggieCups: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}veggie_cups'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mealType: $FoodEntriesTable.$convertermealType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}meal_type'],
        )!,
      ),
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_verified'],
      )!,
    );
  }

  @override
  $FoodEntriesTable createAlias(String alias) {
    return $FoodEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FoodUnit, String, String> $converterunit =
      const EnumNameConverter<FoodUnit>(FoodUnit.values);
  static JsonTypeConverter2<MealType, String, String> $convertermealType =
      const EnumNameConverter<MealType>(MealType.values);
}

class FoodEntry extends DataClass implements Insertable<FoodEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final DateTime? deletedAt;
  final int version;
  final DateTime entryTimestamp;
  final double quantity;
  final FoodUnit unit;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final double fiberG;
  final double addedSugarG;
  final double fruitCups;
  final double veggieCups;
  final String name;
  final MealType mealType;
  final bool isVerified;
  const FoodEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.deletedAt,
    required this.version,
    required this.entryTimestamp,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.fiberG,
    required this.addedSugarG,
    required this.fruitCups,
    required this.veggieCups,
    required this.name,
    required this.mealType,
    required this.isVerified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    map['entry_timestamp'] = Variable<DateTime>(entryTimestamp);
    map['quantity'] = Variable<double>(quantity);
    {
      map['unit'] = Variable<String>(
        $FoodEntriesTable.$converterunit.toSql(unit),
      );
    }
    map['calories'] = Variable<double>(calories);
    map['protein_g'] = Variable<double>(proteinG);
    map['carbs_g'] = Variable<double>(carbsG);
    map['fats_g'] = Variable<double>(fatsG);
    map['fiber_g'] = Variable<double>(fiberG);
    map['added_sugar_g'] = Variable<double>(addedSugarG);
    map['fruit_cups'] = Variable<double>(fruitCups);
    map['veggie_cups'] = Variable<double>(veggieCups);
    map['name'] = Variable<String>(name);
    {
      map['meal_type'] = Variable<String>(
        $FoodEntriesTable.$convertermealType.toSql(mealType),
      );
    }
    map['is_verified'] = Variable<bool>(isVerified);
    return map;
  }

  FoodEntriesCompanion toCompanion(bool nullToAbsent) {
    return FoodEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      userId: Value(userId),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
      entryTimestamp: Value(entryTimestamp),
      quantity: Value(quantity),
      unit: Value(unit),
      calories: Value(calories),
      proteinG: Value(proteinG),
      carbsG: Value(carbsG),
      fatsG: Value(fatsG),
      fiberG: Value(fiberG),
      addedSugarG: Value(addedSugarG),
      fruitCups: Value(fruitCups),
      veggieCups: Value(veggieCups),
      name: Value(name),
      mealType: Value(mealType),
      isVerified: Value(isVerified),
    );
  }

  factory FoodEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userId: serializer.fromJson<String>(json['userId']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
      entryTimestamp: serializer.fromJson<DateTime>(json['entryTimestamp']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: $FoodEntriesTable.$converterunit.fromJson(
        serializer.fromJson<String>(json['unit']),
      ),
      calories: serializer.fromJson<double>(json['calories']),
      proteinG: serializer.fromJson<double>(json['proteinG']),
      carbsG: serializer.fromJson<double>(json['carbsG']),
      fatsG: serializer.fromJson<double>(json['fatsG']),
      fiberG: serializer.fromJson<double>(json['fiberG']),
      addedSugarG: serializer.fromJson<double>(json['addedSugarG']),
      fruitCups: serializer.fromJson<double>(json['fruitCups']),
      veggieCups: serializer.fromJson<double>(json['veggieCups']),
      name: serializer.fromJson<String>(json['name']),
      mealType: $FoodEntriesTable.$convertermealType.fromJson(
        serializer.fromJson<String>(json['mealType']),
      ),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userId': serializer.toJson<String>(userId),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
      'entryTimestamp': serializer.toJson<DateTime>(entryTimestamp),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(
        $FoodEntriesTable.$converterunit.toJson(unit),
      ),
      'calories': serializer.toJson<double>(calories),
      'proteinG': serializer.toJson<double>(proteinG),
      'carbsG': serializer.toJson<double>(carbsG),
      'fatsG': serializer.toJson<double>(fatsG),
      'fiberG': serializer.toJson<double>(fiberG),
      'addedSugarG': serializer.toJson<double>(addedSugarG),
      'fruitCups': serializer.toJson<double>(fruitCups),
      'veggieCups': serializer.toJson<double>(veggieCups),
      'name': serializer.toJson<String>(name),
      'mealType': serializer.toJson<String>(
        $FoodEntriesTable.$convertermealType.toJson(mealType),
      ),
      'isVerified': serializer.toJson<bool>(isVerified),
    };
  }

  FoodEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
    DateTime? entryTimestamp,
    double? quantity,
    FoodUnit? unit,
    double? calories,
    double? proteinG,
    double? carbsG,
    double? fatsG,
    double? fiberG,
    double? addedSugarG,
    double? fruitCups,
    double? veggieCups,
    String? name,
    MealType? mealType,
    bool? isVerified,
  }) => FoodEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userId: userId ?? this.userId,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
    entryTimestamp: entryTimestamp ?? this.entryTimestamp,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    calories: calories ?? this.calories,
    proteinG: proteinG ?? this.proteinG,
    carbsG: carbsG ?? this.carbsG,
    fatsG: fatsG ?? this.fatsG,
    fiberG: fiberG ?? this.fiberG,
    addedSugarG: addedSugarG ?? this.addedSugarG,
    fruitCups: fruitCups ?? this.fruitCups,
    veggieCups: veggieCups ?? this.veggieCups,
    name: name ?? this.name,
    mealType: mealType ?? this.mealType,
    isVerified: isVerified ?? this.isVerified,
  );
  FoodEntry copyWithCompanion(FoodEntriesCompanion data) {
    return FoodEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
      entryTimestamp: data.entryTimestamp.present
          ? data.entryTimestamp.value
          : this.entryTimestamp,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatsG: data.fatsG.present ? data.fatsG.value : this.fatsG,
      fiberG: data.fiberG.present ? data.fiberG.value : this.fiberG,
      addedSugarG: data.addedSugarG.present
          ? data.addedSugarG.value
          : this.addedSugarG,
      fruitCups: data.fruitCups.present ? data.fruitCups.value : this.fruitCups,
      veggieCups: data.veggieCups.present
          ? data.veggieCups.value
          : this.veggieCups,
      name: data.name.present ? data.name.value : this.name,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('entryTimestamp: $entryTimestamp, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatsG: $fatsG, ')
          ..write('fiberG: $fiberG, ')
          ..write('addedSugarG: $addedSugarG, ')
          ..write('fruitCups: $fruitCups, ')
          ..write('veggieCups: $veggieCups, ')
          ..write('name: $name, ')
          ..write('mealType: $mealType, ')
          ..write('isVerified: $isVerified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    entryTimestamp,
    quantity,
    unit,
    calories,
    proteinG,
    carbsG,
    fatsG,
    fiberG,
    addedSugarG,
    fruitCups,
    veggieCups,
    name,
    mealType,
    isVerified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userId == this.userId &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version &&
          other.entryTimestamp == this.entryTimestamp &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.calories == this.calories &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatsG == this.fatsG &&
          other.fiberG == this.fiberG &&
          other.addedSugarG == this.addedSugarG &&
          other.fruitCups == this.fruitCups &&
          other.veggieCups == this.veggieCups &&
          other.name == this.name &&
          other.mealType == this.mealType &&
          other.isVerified == this.isVerified);
}

class FoodEntriesCompanion extends UpdateCompanion<FoodEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> userId;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<DateTime> entryTimestamp;
  final Value<double> quantity;
  final Value<FoodUnit> unit;
  final Value<double> calories;
  final Value<double> proteinG;
  final Value<double> carbsG;
  final Value<double> fatsG;
  final Value<double> fiberG;
  final Value<double> addedSugarG;
  final Value<double> fruitCups;
  final Value<double> veggieCups;
  final Value<String> name;
  final Value<MealType> mealType;
  final Value<bool> isVerified;
  final Value<int> rowid;
  const FoodEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.entryTimestamp = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatsG = const Value.absent(),
    this.fiberG = const Value.absent(),
    this.addedSugarG = const Value.absent(),
    this.fruitCups = const Value.absent(),
    this.veggieCups = const Value.absent(),
    this.name = const Value.absent(),
    this.mealType = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String userId,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime entryTimestamp,
    required double quantity,
    required FoodUnit unit,
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatsG = const Value.absent(),
    this.fiberG = const Value.absent(),
    this.addedSugarG = const Value.absent(),
    this.fruitCups = const Value.absent(),
    this.veggieCups = const Value.absent(),
    required String name,
    required MealType mealType,
    this.isVerified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       entryTimestamp = Value(entryTimestamp),
       quantity = Value(quantity),
       unit = Value(unit),
       name = Value(name),
       mealType = Value(mealType);
  static Insertable<FoodEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? userId,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<DateTime>? entryTimestamp,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? calories,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatsG,
    Expression<double>? fiberG,
    Expression<double>? addedSugarG,
    Expression<double>? fruitCups,
    Expression<double>? veggieCups,
    Expression<String>? name,
    Expression<String>? mealType,
    Expression<bool>? isVerified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (userId != null) 'user_id': userId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (entryTimestamp != null) 'entry_timestamp': entryTimestamp,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (calories != null) 'calories': calories,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatsG != null) 'fats_g': fatsG,
      if (fiberG != null) 'fiber_g': fiberG,
      if (addedSugarG != null) 'added_sugar_g': addedSugarG,
      if (fruitCups != null) 'fruit_cups': fruitCups,
      if (veggieCups != null) 'veggie_cups': veggieCups,
      if (name != null) 'name': name,
      if (mealType != null) 'meal_type': mealType,
      if (isVerified != null) 'is_verified': isVerified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? userId,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<DateTime>? entryTimestamp,
    Value<double>? quantity,
    Value<FoodUnit>? unit,
    Value<double>? calories,
    Value<double>? proteinG,
    Value<double>? carbsG,
    Value<double>? fatsG,
    Value<double>? fiberG,
    Value<double>? addedSugarG,
    Value<double>? fruitCups,
    Value<double>? veggieCups,
    Value<String>? name,
    Value<MealType>? mealType,
    Value<bool>? isVerified,
    Value<int>? rowid,
  }) {
    return FoodEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      entryTimestamp: entryTimestamp ?? this.entryTimestamp,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatsG: fatsG ?? this.fatsG,
      fiberG: fiberG ?? this.fiberG,
      addedSugarG: addedSugarG ?? this.addedSugarG,
      fruitCups: fruitCups ?? this.fruitCups,
      veggieCups: veggieCups ?? this.veggieCups,
      name: name ?? this.name,
      mealType: mealType ?? this.mealType,
      isVerified: isVerified ?? this.isVerified,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (entryTimestamp.present) {
      map['entry_timestamp'] = Variable<DateTime>(entryTimestamp.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $FoodEntriesTable.$converterunit.toSql(unit.value),
      );
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatsG.present) {
      map['fats_g'] = Variable<double>(fatsG.value);
    }
    if (fiberG.present) {
      map['fiber_g'] = Variable<double>(fiberG.value);
    }
    if (addedSugarG.present) {
      map['added_sugar_g'] = Variable<double>(addedSugarG.value);
    }
    if (fruitCups.present) {
      map['fruit_cups'] = Variable<double>(fruitCups.value);
    }
    if (veggieCups.present) {
      map['veggie_cups'] = Variable<double>(veggieCups.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(
        $FoodEntriesTable.$convertermealType.toSql(mealType.value),
      );
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('entryTimestamp: $entryTimestamp, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatsG: $fatsG, ')
          ..write('fiberG: $fiberG, ')
          ..write('addedSugarG: $addedSugarG, ')
          ..write('fruitCups: $fruitCups, ')
          ..write('veggieCups: $veggieCups, ')
          ..write('name: $name, ')
          ..write('mealType: $mealType, ')
          ..write('isVerified: $isVerified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WaterEntriesTable extends WaterEntries
    with TableInfo<$WaterEntriesTable, WaterEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: genUuidV7,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _entryTimestampMeta = const VerificationMeta(
    'entryTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> entryTimestamp =
      GeneratedColumn<DateTime>(
        'entry_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    entryTimestamp,
    amount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('entry_timestamp')) {
      context.handle(
        _entryTimestampMeta,
        entryTimestamp.isAcceptableOrUnknown(
          data['entry_timestamp']!,
          _entryTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entryTimestampMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      entryTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_timestamp'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
    );
  }

  @override
  $WaterEntriesTable createAlias(String alias) {
    return $WaterEntriesTable(attachedDatabase, alias);
  }
}

class WaterEntry extends DataClass implements Insertable<WaterEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final DateTime? deletedAt;
  final int version;
  final DateTime entryTimestamp;
  final double amount;
  const WaterEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.deletedAt,
    required this.version,
    required this.entryTimestamp,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    map['entry_timestamp'] = Variable<DateTime>(entryTimestamp);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  WaterEntriesCompanion toCompanion(bool nullToAbsent) {
    return WaterEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      userId: Value(userId),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
      entryTimestamp: Value(entryTimestamp),
      amount: Value(amount),
    );
  }

  factory WaterEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userId: serializer.fromJson<String>(json['userId']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
      entryTimestamp: serializer.fromJson<DateTime>(json['entryTimestamp']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userId': serializer.toJson<String>(userId),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
      'entryTimestamp': serializer.toJson<DateTime>(entryTimestamp),
      'amount': serializer.toJson<double>(amount),
    };
  }

  WaterEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
    DateTime? entryTimestamp,
    double? amount,
  }) => WaterEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userId: userId ?? this.userId,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
    entryTimestamp: entryTimestamp ?? this.entryTimestamp,
    amount: amount ?? this.amount,
  );
  WaterEntry copyWithCompanion(WaterEntriesCompanion data) {
    return WaterEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
      entryTimestamp: data.entryTimestamp.present
          ? data.entryTimestamp.value
          : this.entryTimestamp,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('entryTimestamp: $entryTimestamp, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    entryTimestamp,
    amount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userId == this.userId &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version &&
          other.entryTimestamp == this.entryTimestamp &&
          other.amount == this.amount);
}

class WaterEntriesCompanion extends UpdateCompanion<WaterEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> userId;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<DateTime> entryTimestamp;
  final Value<double> amount;
  final Value<int> rowid;
  const WaterEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.entryTimestamp = const Value.absent(),
    this.amount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WaterEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String userId,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime entryTimestamp,
    required double amount,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       entryTimestamp = Value(entryTimestamp),
       amount = Value(amount);
  static Insertable<WaterEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? userId,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<DateTime>? entryTimestamp,
    Expression<double>? amount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (userId != null) 'user_id': userId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (entryTimestamp != null) 'entry_timestamp': entryTimestamp,
      if (amount != null) 'amount': amount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WaterEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? userId,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<DateTime>? entryTimestamp,
    Value<double>? amount,
    Value<int>? rowid,
  }) {
    return WaterEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      entryTimestamp: entryTimestamp ?? this.entryTimestamp,
      amount: amount ?? this.amount,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (entryTimestamp.present) {
      map['entry_timestamp'] = Variable<DateTime>(entryTimestamp.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('entryTimestamp: $entryTimestamp, ')
          ..write('amount: $amount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightEntriesTable extends WeightEntries
    with TableInfo<$WeightEntriesTable, WeightEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: genUuidV7,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _entryTimestampMeta = const VerificationMeta(
    'entryTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> entryTimestamp =
      GeneratedColumn<DateTime>(
        'entry_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    entryTimestamp,
    weight,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('entry_timestamp')) {
      context.handle(
        _entryTimestampMeta,
        entryTimestamp.isAcceptableOrUnknown(
          data['entry_timestamp']!,
          _entryTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entryTimestampMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      entryTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_timestamp'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
    );
  }

  @override
  $WeightEntriesTable createAlias(String alias) {
    return $WeightEntriesTable(attachedDatabase, alias);
  }
}

class WeightEntry extends DataClass implements Insertable<WeightEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final DateTime? deletedAt;
  final int version;
  final DateTime entryTimestamp;
  final double weight;
  const WeightEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.deletedAt,
    required this.version,
    required this.entryTimestamp,
    required this.weight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    map['entry_timestamp'] = Variable<DateTime>(entryTimestamp);
    map['weight'] = Variable<double>(weight);
    return map;
  }

  WeightEntriesCompanion toCompanion(bool nullToAbsent) {
    return WeightEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      userId: Value(userId),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
      entryTimestamp: Value(entryTimestamp),
      weight: Value(weight),
    );
  }

  factory WeightEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userId: serializer.fromJson<String>(json['userId']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
      entryTimestamp: serializer.fromJson<DateTime>(json['entryTimestamp']),
      weight: serializer.fromJson<double>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userId': serializer.toJson<String>(userId),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
      'entryTimestamp': serializer.toJson<DateTime>(entryTimestamp),
      'weight': serializer.toJson<double>(weight),
    };
  }

  WeightEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
    DateTime? entryTimestamp,
    double? weight,
  }) => WeightEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userId: userId ?? this.userId,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
    entryTimestamp: entryTimestamp ?? this.entryTimestamp,
    weight: weight ?? this.weight,
  );
  WeightEntry copyWithCompanion(WeightEntriesCompanion data) {
    return WeightEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
      entryTimestamp: data.entryTimestamp.present
          ? data.entryTimestamp.value
          : this.entryTimestamp,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('entryTimestamp: $entryTimestamp, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    entryTimestamp,
    weight,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userId == this.userId &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version &&
          other.entryTimestamp == this.entryTimestamp &&
          other.weight == this.weight);
}

class WeightEntriesCompanion extends UpdateCompanion<WeightEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> userId;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<DateTime> entryTimestamp;
  final Value<double> weight;
  final Value<int> rowid;
  const WeightEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.entryTimestamp = const Value.absent(),
    this.weight = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String userId,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime entryTimestamp,
    required double weight,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       entryTimestamp = Value(entryTimestamp),
       weight = Value(weight);
  static Insertable<WeightEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? userId,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<DateTime>? entryTimestamp,
    Expression<double>? weight,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (userId != null) 'user_id': userId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (entryTimestamp != null) 'entry_timestamp': entryTimestamp,
      if (weight != null) 'weight': weight,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? userId,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<DateTime>? entryTimestamp,
    Value<double>? weight,
    Value<int>? rowid,
  }) {
    return WeightEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      entryTimestamp: entryTimestamp ?? this.entryTimestamp,
      weight: weight ?? this.weight,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (entryTimestamp.present) {
      map['entry_timestamp'] = Variable<DateTime>(entryTimestamp.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('entryTimestamp: $entryTimestamp, ')
          ..write('weight: $weight, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackedSupplementsTable extends TrackedSupplements
    with TableInfo<$TrackedSupplementsTable, TrackedSupplement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackedSupplementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: genUuidV7,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SupplementType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SupplementType>($TrackedSupplementsTable.$convertertype);
  static const VerificationMeta _dailyTargetCountMeta = const VerificationMeta(
    'dailyTargetCount',
  );
  @override
  late final GeneratedColumn<int> dailyTargetCount = GeneratedColumn<int>(
    'daily_target_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    name,
    type,
    dailyTargetCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracked_supplements';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackedSupplement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('daily_target_count')) {
      context.handle(
        _dailyTargetCountMeta,
        dailyTargetCount.isAcceptableOrUnknown(
          data['daily_target_count']!,
          _dailyTargetCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackedSupplement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackedSupplement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $TrackedSupplementsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      dailyTargetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_target_count'],
      ),
    );
  }

  @override
  $TrackedSupplementsTable createAlias(String alias) {
    return $TrackedSupplementsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SupplementType, String, String> $convertertype =
      const EnumNameConverter<SupplementType>(SupplementType.values);
}

class TrackedSupplement extends DataClass
    implements Insertable<TrackedSupplement> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final DateTime? deletedAt;
  final int version;
  final String name;
  final SupplementType type;
  final int? dailyTargetCount;
  const TrackedSupplement({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.deletedAt,
    required this.version,
    required this.name,
    required this.type,
    this.dailyTargetCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>(
        $TrackedSupplementsTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || dailyTargetCount != null) {
      map['daily_target_count'] = Variable<int>(dailyTargetCount);
    }
    return map;
  }

  TrackedSupplementsCompanion toCompanion(bool nullToAbsent) {
    return TrackedSupplementsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      userId: Value(userId),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
      name: Value(name),
      type: Value(type),
      dailyTargetCount: dailyTargetCount == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyTargetCount),
    );
  }

  factory TrackedSupplement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackedSupplement(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userId: serializer.fromJson<String>(json['userId']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
      name: serializer.fromJson<String>(json['name']),
      type: $TrackedSupplementsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      dailyTargetCount: serializer.fromJson<int?>(json['dailyTargetCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userId': serializer.toJson<String>(userId),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $TrackedSupplementsTable.$convertertype.toJson(type),
      ),
      'dailyTargetCount': serializer.toJson<int?>(dailyTargetCount),
    };
  }

  TrackedSupplement copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
    String? name,
    SupplementType? type,
    Value<int?> dailyTargetCount = const Value.absent(),
  }) => TrackedSupplement(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userId: userId ?? this.userId,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
    name: name ?? this.name,
    type: type ?? this.type,
    dailyTargetCount: dailyTargetCount.present
        ? dailyTargetCount.value
        : this.dailyTargetCount,
  );
  TrackedSupplement copyWithCompanion(TrackedSupplementsCompanion data) {
    return TrackedSupplement(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      dailyTargetCount: data.dailyTargetCount.present
          ? data.dailyTargetCount.value
          : this.dailyTargetCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackedSupplement(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('dailyTargetCount: $dailyTargetCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    name,
    type,
    dailyTargetCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackedSupplement &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userId == this.userId &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version &&
          other.name == this.name &&
          other.type == this.type &&
          other.dailyTargetCount == this.dailyTargetCount);
}

class TrackedSupplementsCompanion extends UpdateCompanion<TrackedSupplement> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> userId;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<String> name;
  final Value<SupplementType> type;
  final Value<int?> dailyTargetCount;
  final Value<int> rowid;
  const TrackedSupplementsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.dailyTargetCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackedSupplementsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String userId,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    required String name,
    required SupplementType type,
    this.dailyTargetCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       name = Value(name),
       type = Value(type);
  static Insertable<TrackedSupplement> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? userId,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? dailyTargetCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (userId != null) 'user_id': userId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (dailyTargetCount != null) 'daily_target_count': dailyTargetCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackedSupplementsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? userId,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<String>? name,
    Value<SupplementType>? type,
    Value<int?>? dailyTargetCount,
    Value<int>? rowid,
  }) {
    return TrackedSupplementsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      name: name ?? this.name,
      type: type ?? this.type,
      dailyTargetCount: dailyTargetCount ?? this.dailyTargetCount,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TrackedSupplementsTable.$convertertype.toSql(type.value),
      );
    }
    if (dailyTargetCount.present) {
      map['daily_target_count'] = Variable<int>(dailyTargetCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackedSupplementsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('dailyTargetCount: $dailyTargetCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SupplementEntriesTable extends SupplementEntries
    with TableInfo<$SupplementEntriesTable, SupplementEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: genUuidV7,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _entryTimestampMeta = const VerificationMeta(
    'entryTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> entryTimestamp =
      GeneratedColumn<DateTime>(
        'entry_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _supplementIdMeta = const VerificationMeta(
    'supplementId',
  );
  @override
  late final GeneratedColumn<String> supplementId = GeneratedColumn<String>(
    'supplement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tracked_supplements (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    entryTimestamp,
    supplementId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplement_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplementEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('entry_timestamp')) {
      context.handle(
        _entryTimestampMeta,
        entryTimestamp.isAcceptableOrUnknown(
          data['entry_timestamp']!,
          _entryTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entryTimestampMeta);
    }
    if (data.containsKey('supplement_id')) {
      context.handle(
        _supplementIdMeta,
        supplementId.isAcceptableOrUnknown(
          data['supplement_id']!,
          _supplementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supplementIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplementEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplementEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      entryTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_timestamp'],
      )!,
      supplementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplement_id'],
      )!,
    );
  }

  @override
  $SupplementEntriesTable createAlias(String alias) {
    return $SupplementEntriesTable(attachedDatabase, alias);
  }
}

class SupplementEntry extends DataClass implements Insertable<SupplementEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final DateTime? deletedAt;
  final int version;
  final DateTime entryTimestamp;
  final String supplementId;
  const SupplementEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.deletedAt,
    required this.version,
    required this.entryTimestamp,
    required this.supplementId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    map['entry_timestamp'] = Variable<DateTime>(entryTimestamp);
    map['supplement_id'] = Variable<String>(supplementId);
    return map;
  }

  SupplementEntriesCompanion toCompanion(bool nullToAbsent) {
    return SupplementEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      userId: Value(userId),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
      entryTimestamp: Value(entryTimestamp),
      supplementId: Value(supplementId),
    );
  }

  factory SupplementEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplementEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userId: serializer.fromJson<String>(json['userId']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
      entryTimestamp: serializer.fromJson<DateTime>(json['entryTimestamp']),
      supplementId: serializer.fromJson<String>(json['supplementId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userId': serializer.toJson<String>(userId),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
      'entryTimestamp': serializer.toJson<DateTime>(entryTimestamp),
      'supplementId': serializer.toJson<String>(supplementId),
    };
  }

  SupplementEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
    DateTime? entryTimestamp,
    String? supplementId,
  }) => SupplementEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userId: userId ?? this.userId,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
    entryTimestamp: entryTimestamp ?? this.entryTimestamp,
    supplementId: supplementId ?? this.supplementId,
  );
  SupplementEntry copyWithCompanion(SupplementEntriesCompanion data) {
    return SupplementEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
      entryTimestamp: data.entryTimestamp.present
          ? data.entryTimestamp.value
          : this.entryTimestamp,
      supplementId: data.supplementId.present
          ? data.supplementId.value
          : this.supplementId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplementEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('entryTimestamp: $entryTimestamp, ')
          ..write('supplementId: $supplementId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    entryTimestamp,
    supplementId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplementEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userId == this.userId &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version &&
          other.entryTimestamp == this.entryTimestamp &&
          other.supplementId == this.supplementId);
}

class SupplementEntriesCompanion extends UpdateCompanion<SupplementEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> userId;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<DateTime> entryTimestamp;
  final Value<String> supplementId;
  final Value<int> rowid;
  const SupplementEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.entryTimestamp = const Value.absent(),
    this.supplementId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplementEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String userId,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime entryTimestamp,
    required String supplementId,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       entryTimestamp = Value(entryTimestamp),
       supplementId = Value(supplementId);
  static Insertable<SupplementEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? userId,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<DateTime>? entryTimestamp,
    Expression<String>? supplementId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (userId != null) 'user_id': userId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (entryTimestamp != null) 'entry_timestamp': entryTimestamp,
      if (supplementId != null) 'supplement_id': supplementId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplementEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? userId,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<DateTime>? entryTimestamp,
    Value<String>? supplementId,
    Value<int>? rowid,
  }) {
    return SupplementEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      entryTimestamp: entryTimestamp ?? this.entryTimestamp,
      supplementId: supplementId ?? this.supplementId,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (entryTimestamp.present) {
      map['entry_timestamp'] = Variable<DateTime>(entryTimestamp.value);
    }
    if (supplementId.present) {
      map['supplement_id'] = Variable<String>(supplementId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplementEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('entryTimestamp: $entryTimestamp, ')
          ..write('supplementId: $supplementId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedItemsTable extends SavedItems
    with TableInfo<$SavedItemsTable, SavedItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: genUuidV7,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FoodUnit, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FoodUnit>($SavedItemsTable.$converterunit);
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fatsGMeta = const VerificationMeta('fatsG');
  @override
  late final GeneratedColumn<double> fatsG = GeneratedColumn<double>(
    'fats_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fiberGMeta = const VerificationMeta('fiberG');
  @override
  late final GeneratedColumn<double> fiberG = GeneratedColumn<double>(
    'fiber_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addedSugarGMeta = const VerificationMeta(
    'addedSugarG',
  );
  @override
  late final GeneratedColumn<double> addedSugarG = GeneratedColumn<double>(
    'added_sugar_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fruitCupsMeta = const VerificationMeta(
    'fruitCups',
  );
  @override
  late final GeneratedColumn<double> fruitCups = GeneratedColumn<double>(
    'fruit_cups',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _veggieCupsMeta = const VerificationMeta(
    'veggieCups',
  );
  @override
  late final GeneratedColumn<double> veggieCups = GeneratedColumn<double>(
    'veggie_cups',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    quantity,
    unit,
    calories,
    proteinG,
    carbsG,
    fatsG,
    fiberG,
    addedSugarG,
    fruitCups,
    veggieCups,
    name,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    }
    if (data.containsKey('fats_g')) {
      context.handle(
        _fatsGMeta,
        fatsG.isAcceptableOrUnknown(data['fats_g']!, _fatsGMeta),
      );
    }
    if (data.containsKey('fiber_g')) {
      context.handle(
        _fiberGMeta,
        fiberG.isAcceptableOrUnknown(data['fiber_g']!, _fiberGMeta),
      );
    }
    if (data.containsKey('added_sugar_g')) {
      context.handle(
        _addedSugarGMeta,
        addedSugarG.isAcceptableOrUnknown(
          data['added_sugar_g']!,
          _addedSugarGMeta,
        ),
      );
    }
    if (data.containsKey('fruit_cups')) {
      context.handle(
        _fruitCupsMeta,
        fruitCups.isAcceptableOrUnknown(data['fruit_cups']!, _fruitCupsMeta),
      );
    }
    if (data.containsKey('veggie_cups')) {
      context.handle(
        _veggieCupsMeta,
        veggieCups.isAcceptableOrUnknown(data['veggie_cups']!, _veggieCupsMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: $SavedItemsTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        )!,
      ),
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      )!,
      fatsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fats_g'],
      )!,
      fiberG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_g'],
      )!,
      addedSugarG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}added_sugar_g'],
      )!,
      fruitCups: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fruit_cups'],
      )!,
      veggieCups: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}veggie_cups'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $SavedItemsTable createAlias(String alias) {
    return $SavedItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FoodUnit, String, String> $converterunit =
      const EnumNameConverter<FoodUnit>(FoodUnit.values);
}

class SavedItem extends DataClass implements Insertable<SavedItem> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final DateTime? deletedAt;
  final int version;
  final double quantity;
  final FoodUnit unit;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final double fiberG;
  final double addedSugarG;
  final double fruitCups;
  final double veggieCups;
  final String name;
  const SavedItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.deletedAt,
    required this.version,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.fiberG,
    required this.addedSugarG,
    required this.fruitCups,
    required this.veggieCups,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    map['quantity'] = Variable<double>(quantity);
    {
      map['unit'] = Variable<String>(
        $SavedItemsTable.$converterunit.toSql(unit),
      );
    }
    map['calories'] = Variable<double>(calories);
    map['protein_g'] = Variable<double>(proteinG);
    map['carbs_g'] = Variable<double>(carbsG);
    map['fats_g'] = Variable<double>(fatsG);
    map['fiber_g'] = Variable<double>(fiberG);
    map['added_sugar_g'] = Variable<double>(addedSugarG);
    map['fruit_cups'] = Variable<double>(fruitCups);
    map['veggie_cups'] = Variable<double>(veggieCups);
    map['name'] = Variable<String>(name);
    return map;
  }

  SavedItemsCompanion toCompanion(bool nullToAbsent) {
    return SavedItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      userId: Value(userId),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
      quantity: Value(quantity),
      unit: Value(unit),
      calories: Value(calories),
      proteinG: Value(proteinG),
      carbsG: Value(carbsG),
      fatsG: Value(fatsG),
      fiberG: Value(fiberG),
      addedSugarG: Value(addedSugarG),
      fruitCups: Value(fruitCups),
      veggieCups: Value(veggieCups),
      name: Value(name),
    );
  }

  factory SavedItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedItem(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userId: serializer.fromJson<String>(json['userId']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: $SavedItemsTable.$converterunit.fromJson(
        serializer.fromJson<String>(json['unit']),
      ),
      calories: serializer.fromJson<double>(json['calories']),
      proteinG: serializer.fromJson<double>(json['proteinG']),
      carbsG: serializer.fromJson<double>(json['carbsG']),
      fatsG: serializer.fromJson<double>(json['fatsG']),
      fiberG: serializer.fromJson<double>(json['fiberG']),
      addedSugarG: serializer.fromJson<double>(json['addedSugarG']),
      fruitCups: serializer.fromJson<double>(json['fruitCups']),
      veggieCups: serializer.fromJson<double>(json['veggieCups']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userId': serializer.toJson<String>(userId),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(
        $SavedItemsTable.$converterunit.toJson(unit),
      ),
      'calories': serializer.toJson<double>(calories),
      'proteinG': serializer.toJson<double>(proteinG),
      'carbsG': serializer.toJson<double>(carbsG),
      'fatsG': serializer.toJson<double>(fatsG),
      'fiberG': serializer.toJson<double>(fiberG),
      'addedSugarG': serializer.toJson<double>(addedSugarG),
      'fruitCups': serializer.toJson<double>(fruitCups),
      'veggieCups': serializer.toJson<double>(veggieCups),
      'name': serializer.toJson<String>(name),
    };
  }

  SavedItem copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
    double? quantity,
    FoodUnit? unit,
    double? calories,
    double? proteinG,
    double? carbsG,
    double? fatsG,
    double? fiberG,
    double? addedSugarG,
    double? fruitCups,
    double? veggieCups,
    String? name,
  }) => SavedItem(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userId: userId ?? this.userId,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    calories: calories ?? this.calories,
    proteinG: proteinG ?? this.proteinG,
    carbsG: carbsG ?? this.carbsG,
    fatsG: fatsG ?? this.fatsG,
    fiberG: fiberG ?? this.fiberG,
    addedSugarG: addedSugarG ?? this.addedSugarG,
    fruitCups: fruitCups ?? this.fruitCups,
    veggieCups: veggieCups ?? this.veggieCups,
    name: name ?? this.name,
  );
  SavedItem copyWithCompanion(SavedItemsCompanion data) {
    return SavedItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatsG: data.fatsG.present ? data.fatsG.value : this.fatsG,
      fiberG: data.fiberG.present ? data.fiberG.value : this.fiberG,
      addedSugarG: data.addedSugarG.present
          ? data.addedSugarG.value
          : this.addedSugarG,
      fruitCups: data.fruitCups.present ? data.fruitCups.value : this.fruitCups,
      veggieCups: data.veggieCups.present
          ? data.veggieCups.value
          : this.veggieCups,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatsG: $fatsG, ')
          ..write('fiberG: $fiberG, ')
          ..write('addedSugarG: $addedSugarG, ')
          ..write('fruitCups: $fruitCups, ')
          ..write('veggieCups: $veggieCups, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    userId,
    deletedAt,
    version,
    quantity,
    unit,
    calories,
    proteinG,
    carbsG,
    fatsG,
    fiberG,
    addedSugarG,
    fruitCups,
    veggieCups,
    name,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userId == this.userId &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.calories == this.calories &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatsG == this.fatsG &&
          other.fiberG == this.fiberG &&
          other.addedSugarG == this.addedSugarG &&
          other.fruitCups == this.fruitCups &&
          other.veggieCups == this.veggieCups &&
          other.name == this.name);
}

class SavedItemsCompanion extends UpdateCompanion<SavedItem> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> userId;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<double> quantity;
  final Value<FoodUnit> unit;
  final Value<double> calories;
  final Value<double> proteinG;
  final Value<double> carbsG;
  final Value<double> fatsG;
  final Value<double> fiberG;
  final Value<double> addedSugarG;
  final Value<double> fruitCups;
  final Value<double> veggieCups;
  final Value<String> name;
  final Value<int> rowid;
  const SavedItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatsG = const Value.absent(),
    this.fiberG = const Value.absent(),
    this.addedSugarG = const Value.absent(),
    this.fruitCups = const Value.absent(),
    this.veggieCups = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedItemsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String userId,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    required double quantity,
    required FoodUnit unit,
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatsG = const Value.absent(),
    this.fiberG = const Value.absent(),
    this.addedSugarG = const Value.absent(),
    this.fruitCups = const Value.absent(),
    this.veggieCups = const Value.absent(),
    required String name,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       quantity = Value(quantity),
       unit = Value(unit),
       name = Value(name);
  static Insertable<SavedItem> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? userId,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? calories,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatsG,
    Expression<double>? fiberG,
    Expression<double>? addedSugarG,
    Expression<double>? fruitCups,
    Expression<double>? veggieCups,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (userId != null) 'user_id': userId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (calories != null) 'calories': calories,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatsG != null) 'fats_g': fatsG,
      if (fiberG != null) 'fiber_g': fiberG,
      if (addedSugarG != null) 'added_sugar_g': addedSugarG,
      if (fruitCups != null) 'fruit_cups': fruitCups,
      if (veggieCups != null) 'veggie_cups': veggieCups,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedItemsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? userId,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<double>? quantity,
    Value<FoodUnit>? unit,
    Value<double>? calories,
    Value<double>? proteinG,
    Value<double>? carbsG,
    Value<double>? fatsG,
    Value<double>? fiberG,
    Value<double>? addedSugarG,
    Value<double>? fruitCups,
    Value<double>? veggieCups,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return SavedItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatsG: fatsG ?? this.fatsG,
      fiberG: fiberG ?? this.fiberG,
      addedSugarG: addedSugarG ?? this.addedSugarG,
      fruitCups: fruitCups ?? this.fruitCups,
      veggieCups: veggieCups ?? this.veggieCups,
      name: name ?? this.name,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $SavedItemsTable.$converterunit.toSql(unit.value),
      );
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatsG.present) {
      map['fats_g'] = Variable<double>(fatsG.value);
    }
    if (fiberG.present) {
      map['fiber_g'] = Variable<double>(fiberG.value);
    }
    if (addedSugarG.present) {
      map['added_sugar_g'] = Variable<double>(addedSugarG.value);
    }
    if (fruitCups.present) {
      map['fruit_cups'] = Variable<double>(fruitCups.value);
    }
    if (veggieCups.present) {
      map['veggie_cups'] = Variable<double>(veggieCups.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatsG: $fatsG, ')
          ..write('fiberG: $fiberG, ')
          ..write('addedSugarG: $addedSugarG, ')
          ..write('fruitCups: $fruitCups, ')
          ..write('veggieCups: $veggieCups, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LookupCacheEntriesTable extends LookupCacheEntries
    with TableInfo<$LookupCacheEntriesTable, LookupCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LookupCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: genUuidV7,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FoodUnit, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FoodUnit>($LookupCacheEntriesTable.$converterunit);
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fatsGMeta = const VerificationMeta('fatsG');
  @override
  late final GeneratedColumn<double> fatsG = GeneratedColumn<double>(
    'fats_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fiberGMeta = const VerificationMeta('fiberG');
  @override
  late final GeneratedColumn<double> fiberG = GeneratedColumn<double>(
    'fiber_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addedSugarGMeta = const VerificationMeta(
    'addedSugarG',
  );
  @override
  late final GeneratedColumn<double> addedSugarG = GeneratedColumn<double>(
    'added_sugar_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fruitCupsMeta = const VerificationMeta(
    'fruitCups',
  );
  @override
  late final GeneratedColumn<double> fruitCups = GeneratedColumn<double>(
    'fruit_cups',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _veggieCupsMeta = const VerificationMeta(
    'veggieCups',
  );
  @override
  late final GeneratedColumn<double> veggieCups = GeneratedColumn<double>(
    'veggie_cups',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceRefMeta = const VerificationMeta(
    'sourceRef',
  );
  @override
  late final GeneratedColumn<String> sourceRef = GeneratedColumn<String>(
    'source_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _useCountMeta = const VerificationMeta(
    'useCount',
  );
  @override
  late final GeneratedColumn<int> useCount = GeneratedColumn<int>(
    'use_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    userId,
    quantity,
    unit,
    calories,
    proteinG,
    carbsG,
    fatsG,
    fiberG,
    addedSugarG,
    fruitCups,
    veggieCups,
    name,
    sourceRef,
    useCount,
    lastUsedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lookup_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LookupCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    }
    if (data.containsKey('fats_g')) {
      context.handle(
        _fatsGMeta,
        fatsG.isAcceptableOrUnknown(data['fats_g']!, _fatsGMeta),
      );
    }
    if (data.containsKey('fiber_g')) {
      context.handle(
        _fiberGMeta,
        fiberG.isAcceptableOrUnknown(data['fiber_g']!, _fiberGMeta),
      );
    }
    if (data.containsKey('added_sugar_g')) {
      context.handle(
        _addedSugarGMeta,
        addedSugarG.isAcceptableOrUnknown(
          data['added_sugar_g']!,
          _addedSugarGMeta,
        ),
      );
    }
    if (data.containsKey('fruit_cups')) {
      context.handle(
        _fruitCupsMeta,
        fruitCups.isAcceptableOrUnknown(data['fruit_cups']!, _fruitCupsMeta),
      );
    }
    if (data.containsKey('veggie_cups')) {
      context.handle(
        _veggieCupsMeta,
        veggieCups.isAcceptableOrUnknown(data['veggie_cups']!, _veggieCupsMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('source_ref')) {
      context.handle(
        _sourceRefMeta,
        sourceRef.isAcceptableOrUnknown(data['source_ref']!, _sourceRefMeta),
      );
    }
    if (data.containsKey('use_count')) {
      context.handle(
        _useCountMeta,
        useCount.isAcceptableOrUnknown(data['use_count']!, _useCountMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LookupCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LookupCacheEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: $LookupCacheEntriesTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        )!,
      ),
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      )!,
      fatsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fats_g'],
      )!,
      fiberG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_g'],
      )!,
      addedSugarG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}added_sugar_g'],
      )!,
      fruitCups: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fruit_cups'],
      )!,
      veggieCups: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}veggie_cups'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sourceRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_ref'],
      ),
      useCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}use_count'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      )!,
    );
  }

  @override
  $LookupCacheEntriesTable createAlias(String alias) {
    return $LookupCacheEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FoodUnit, String, String> $converterunit =
      const EnumNameConverter<FoodUnit>(FoodUnit.values);
}

class LookupCacheEntry extends DataClass
    implements Insertable<LookupCacheEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final double quantity;
  final FoodUnit unit;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final double fiberG;
  final double addedSugarG;
  final double fruitCups;
  final double veggieCups;
  final String name;
  final String? sourceRef;
  final int useCount;
  final DateTime lastUsedAt;
  const LookupCacheEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.fiberG,
    required this.addedSugarG,
    required this.fruitCups,
    required this.veggieCups,
    required this.name,
    this.sourceRef,
    required this.useCount,
    required this.lastUsedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['user_id'] = Variable<String>(userId);
    map['quantity'] = Variable<double>(quantity);
    {
      map['unit'] = Variable<String>(
        $LookupCacheEntriesTable.$converterunit.toSql(unit),
      );
    }
    map['calories'] = Variable<double>(calories);
    map['protein_g'] = Variable<double>(proteinG);
    map['carbs_g'] = Variable<double>(carbsG);
    map['fats_g'] = Variable<double>(fatsG);
    map['fiber_g'] = Variable<double>(fiberG);
    map['added_sugar_g'] = Variable<double>(addedSugarG);
    map['fruit_cups'] = Variable<double>(fruitCups);
    map['veggie_cups'] = Variable<double>(veggieCups);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sourceRef != null) {
      map['source_ref'] = Variable<String>(sourceRef);
    }
    map['use_count'] = Variable<int>(useCount);
    map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    return map;
  }

  LookupCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return LookupCacheEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      userId: Value(userId),
      quantity: Value(quantity),
      unit: Value(unit),
      calories: Value(calories),
      proteinG: Value(proteinG),
      carbsG: Value(carbsG),
      fatsG: Value(fatsG),
      fiberG: Value(fiberG),
      addedSugarG: Value(addedSugarG),
      fruitCups: Value(fruitCups),
      veggieCups: Value(veggieCups),
      name: Value(name),
      sourceRef: sourceRef == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRef),
      useCount: Value(useCount),
      lastUsedAt: Value(lastUsedAt),
    );
  }

  factory LookupCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LookupCacheEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userId: serializer.fromJson<String>(json['userId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: $LookupCacheEntriesTable.$converterunit.fromJson(
        serializer.fromJson<String>(json['unit']),
      ),
      calories: serializer.fromJson<double>(json['calories']),
      proteinG: serializer.fromJson<double>(json['proteinG']),
      carbsG: serializer.fromJson<double>(json['carbsG']),
      fatsG: serializer.fromJson<double>(json['fatsG']),
      fiberG: serializer.fromJson<double>(json['fiberG']),
      addedSugarG: serializer.fromJson<double>(json['addedSugarG']),
      fruitCups: serializer.fromJson<double>(json['fruitCups']),
      veggieCups: serializer.fromJson<double>(json['veggieCups']),
      name: serializer.fromJson<String>(json['name']),
      sourceRef: serializer.fromJson<String?>(json['sourceRef']),
      useCount: serializer.fromJson<int>(json['useCount']),
      lastUsedAt: serializer.fromJson<DateTime>(json['lastUsedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userId': serializer.toJson<String>(userId),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(
        $LookupCacheEntriesTable.$converterunit.toJson(unit),
      ),
      'calories': serializer.toJson<double>(calories),
      'proteinG': serializer.toJson<double>(proteinG),
      'carbsG': serializer.toJson<double>(carbsG),
      'fatsG': serializer.toJson<double>(fatsG),
      'fiberG': serializer.toJson<double>(fiberG),
      'addedSugarG': serializer.toJson<double>(addedSugarG),
      'fruitCups': serializer.toJson<double>(fruitCups),
      'veggieCups': serializer.toJson<double>(veggieCups),
      'name': serializer.toJson<String>(name),
      'sourceRef': serializer.toJson<String?>(sourceRef),
      'useCount': serializer.toJson<int>(useCount),
      'lastUsedAt': serializer.toJson<DateTime>(lastUsedAt),
    };
  }

  LookupCacheEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    double? quantity,
    FoodUnit? unit,
    double? calories,
    double? proteinG,
    double? carbsG,
    double? fatsG,
    double? fiberG,
    double? addedSugarG,
    double? fruitCups,
    double? veggieCups,
    String? name,
    Value<String?> sourceRef = const Value.absent(),
    int? useCount,
    DateTime? lastUsedAt,
  }) => LookupCacheEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userId: userId ?? this.userId,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    calories: calories ?? this.calories,
    proteinG: proteinG ?? this.proteinG,
    carbsG: carbsG ?? this.carbsG,
    fatsG: fatsG ?? this.fatsG,
    fiberG: fiberG ?? this.fiberG,
    addedSugarG: addedSugarG ?? this.addedSugarG,
    fruitCups: fruitCups ?? this.fruitCups,
    veggieCups: veggieCups ?? this.veggieCups,
    name: name ?? this.name,
    sourceRef: sourceRef.present ? sourceRef.value : this.sourceRef,
    useCount: useCount ?? this.useCount,
    lastUsedAt: lastUsedAt ?? this.lastUsedAt,
  );
  LookupCacheEntry copyWithCompanion(LookupCacheEntriesCompanion data) {
    return LookupCacheEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatsG: data.fatsG.present ? data.fatsG.value : this.fatsG,
      fiberG: data.fiberG.present ? data.fiberG.value : this.fiberG,
      addedSugarG: data.addedSugarG.present
          ? data.addedSugarG.value
          : this.addedSugarG,
      fruitCups: data.fruitCups.present ? data.fruitCups.value : this.fruitCups,
      veggieCups: data.veggieCups.present
          ? data.veggieCups.value
          : this.veggieCups,
      name: data.name.present ? data.name.value : this.name,
      sourceRef: data.sourceRef.present ? data.sourceRef.value : this.sourceRef,
      useCount: data.useCount.present ? data.useCount.value : this.useCount,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LookupCacheEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatsG: $fatsG, ')
          ..write('fiberG: $fiberG, ')
          ..write('addedSugarG: $addedSugarG, ')
          ..write('fruitCups: $fruitCups, ')
          ..write('veggieCups: $veggieCups, ')
          ..write('name: $name, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('useCount: $useCount, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    userId,
    quantity,
    unit,
    calories,
    proteinG,
    carbsG,
    fatsG,
    fiberG,
    addedSugarG,
    fruitCups,
    veggieCups,
    name,
    sourceRef,
    useCount,
    lastUsedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LookupCacheEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userId == this.userId &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.calories == this.calories &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatsG == this.fatsG &&
          other.fiberG == this.fiberG &&
          other.addedSugarG == this.addedSugarG &&
          other.fruitCups == this.fruitCups &&
          other.veggieCups == this.veggieCups &&
          other.name == this.name &&
          other.sourceRef == this.sourceRef &&
          other.useCount == this.useCount &&
          other.lastUsedAt == this.lastUsedAt);
}

class LookupCacheEntriesCompanion extends UpdateCompanion<LookupCacheEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> userId;
  final Value<double> quantity;
  final Value<FoodUnit> unit;
  final Value<double> calories;
  final Value<double> proteinG;
  final Value<double> carbsG;
  final Value<double> fatsG;
  final Value<double> fiberG;
  final Value<double> addedSugarG;
  final Value<double> fruitCups;
  final Value<double> veggieCups;
  final Value<String> name;
  final Value<String?> sourceRef;
  final Value<int> useCount;
  final Value<DateTime> lastUsedAt;
  final Value<int> rowid;
  const LookupCacheEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatsG = const Value.absent(),
    this.fiberG = const Value.absent(),
    this.addedSugarG = const Value.absent(),
    this.fruitCups = const Value.absent(),
    this.veggieCups = const Value.absent(),
    this.name = const Value.absent(),
    this.sourceRef = const Value.absent(),
    this.useCount = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LookupCacheEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String userId,
    required double quantity,
    required FoodUnit unit,
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatsG = const Value.absent(),
    this.fiberG = const Value.absent(),
    this.addedSugarG = const Value.absent(),
    this.fruitCups = const Value.absent(),
    this.veggieCups = const Value.absent(),
    required String name,
    this.sourceRef = const Value.absent(),
    this.useCount = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       quantity = Value(quantity),
       unit = Value(unit),
       name = Value(name);
  static Insertable<LookupCacheEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? userId,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? calories,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatsG,
    Expression<double>? fiberG,
    Expression<double>? addedSugarG,
    Expression<double>? fruitCups,
    Expression<double>? veggieCups,
    Expression<String>? name,
    Expression<String>? sourceRef,
    Expression<int>? useCount,
    Expression<DateTime>? lastUsedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (userId != null) 'user_id': userId,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (calories != null) 'calories': calories,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatsG != null) 'fats_g': fatsG,
      if (fiberG != null) 'fiber_g': fiberG,
      if (addedSugarG != null) 'added_sugar_g': addedSugarG,
      if (fruitCups != null) 'fruit_cups': fruitCups,
      if (veggieCups != null) 'veggie_cups': veggieCups,
      if (name != null) 'name': name,
      if (sourceRef != null) 'source_ref': sourceRef,
      if (useCount != null) 'use_count': useCount,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LookupCacheEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? userId,
    Value<double>? quantity,
    Value<FoodUnit>? unit,
    Value<double>? calories,
    Value<double>? proteinG,
    Value<double>? carbsG,
    Value<double>? fatsG,
    Value<double>? fiberG,
    Value<double>? addedSugarG,
    Value<double>? fruitCups,
    Value<double>? veggieCups,
    Value<String>? name,
    Value<String?>? sourceRef,
    Value<int>? useCount,
    Value<DateTime>? lastUsedAt,
    Value<int>? rowid,
  }) {
    return LookupCacheEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatsG: fatsG ?? this.fatsG,
      fiberG: fiberG ?? this.fiberG,
      addedSugarG: addedSugarG ?? this.addedSugarG,
      fruitCups: fruitCups ?? this.fruitCups,
      veggieCups: veggieCups ?? this.veggieCups,
      name: name ?? this.name,
      sourceRef: sourceRef ?? this.sourceRef,
      useCount: useCount ?? this.useCount,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $LookupCacheEntriesTable.$converterunit.toSql(unit.value),
      );
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatsG.present) {
      map['fats_g'] = Variable<double>(fatsG.value);
    }
    if (fiberG.present) {
      map['fiber_g'] = Variable<double>(fiberG.value);
    }
    if (addedSugarG.present) {
      map['added_sugar_g'] = Variable<double>(addedSugarG.value);
    }
    if (fruitCups.present) {
      map['fruit_cups'] = Variable<double>(fruitCups.value);
    }
    if (veggieCups.present) {
      map['veggie_cups'] = Variable<double>(veggieCups.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sourceRef.present) {
      map['source_ref'] = Variable<String>(sourceRef.value);
    }
    if (useCount.present) {
      map['use_count'] = Variable<int>(useCount.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LookupCacheEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatsG: $fatsG, ')
          ..write('fiberG: $fiberG, ')
          ..write('addedSugarG: $addedSugarG, ')
          ..write('fruitCups: $fruitCups, ')
          ..write('veggieCups: $veggieCups, ')
          ..write('name: $name, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('useCount: $useCount, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxEntriesTable extends OutboxEntries
    with TableInfo<$OutboxEntriesTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: genUuidV7,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncOperation, String> operation =
      GeneratedColumn<String>(
        'operation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncOperation>($OutboxEntriesTable.$converteroperation);
  static const VerificationMeta _queuedAtMeta = const VerificationMeta(
    'queuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> queuedAt = GeneratedColumn<DateTime>(
    'queued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    queuedAt,
    retryCount,
    lastAttemptAt,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('queued_at')) {
      context.handle(
        _queuedAtMeta,
        queuedAt.isAcceptableOrUnknown(data['queued_at']!, _queuedAtMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: $OutboxEntriesTable.$converteroperation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}operation'],
        )!,
      ),
      queuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}queued_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $OutboxEntriesTable createAlias(String alias) {
    return $OutboxEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncOperation, String, String> $converteroperation =
      const EnumNameConverter<SyncOperation>(SyncOperation.values);
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final String id;
  final String entityType;
  final String entityId;
  final SyncOperation operation;
  final DateTime queuedAt;
  final int retryCount;
  final DateTime? lastAttemptAt;
  final String? lastError;
  const OutboxEntry({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.queuedAt,
    required this.retryCount,
    this.lastAttemptAt,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    {
      map['operation'] = Variable<String>(
        $OutboxEntriesTable.$converteroperation.toSql(operation),
      );
    }
    map['queued_at'] = Variable<DateTime>(queuedAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  OutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return OutboxEntriesCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      queuedAt: Value(queuedAt),
      retryCount: Value(retryCount),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: $OutboxEntriesTable.$converteroperation.fromJson(
        serializer.fromJson<String>(json['operation']),
      ),
      queuedAt: serializer.fromJson<DateTime>(json['queuedAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(
        $OutboxEntriesTable.$converteroperation.toJson(operation),
      ),
      'queuedAt': serializer.toJson<DateTime>(queuedAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  OutboxEntry copyWith({
    String? id,
    String? entityType,
    String? entityId,
    SyncOperation? operation,
    DateTime? queuedAt,
    int? retryCount,
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
  }) => OutboxEntry(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    queuedAt: queuedAt ?? this.queuedAt,
    retryCount: retryCount ?? this.retryCount,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  OutboxEntry copyWithCompanion(OutboxEntriesCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      queuedAt: data.queuedAt.present ? data.queuedAt.value : this.queuedAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    queuedAt,
    retryCount,
    lastAttemptAt,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.queuedAt == this.queuedAt &&
          other.retryCount == this.retryCount &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.lastError == this.lastError);
}

class OutboxEntriesCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<SyncOperation> operation;
  final Value<DateTime> queuedAt;
  final Value<int> retryCount;
  final Value<DateTime?> lastAttemptAt;
  final Value<String?> lastError;
  final Value<int> rowid;
  const OutboxEntriesCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.queuedAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityId,
    required SyncOperation operation,
    this.queuedAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation);
  static Insertable<OutboxEntry> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<DateTime>? queuedAt,
    Expression<int>? retryCount,
    Expression<DateTime>? lastAttemptAt,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (queuedAt != null) 'queued_at': queuedAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<SyncOperation>? operation,
    Value<DateTime>? queuedAt,
    Value<int>? retryCount,
    Value<DateTime?>? lastAttemptAt,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return OutboxEntriesCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      queuedAt: queuedAt ?? this.queuedAt,
      retryCount: retryCount ?? this.retryCount,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(
        $OutboxEntriesTable.$converteroperation.toSql(operation.value),
      );
    }
    if (queuedAt.present) {
      map['queued_at'] = Variable<DateTime>(queuedAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntriesCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $PerUserTargetsTable perUserTargets = $PerUserTargetsTable(this);
  late final $FoodEntriesTable foodEntries = $FoodEntriesTable(this);
  late final $WaterEntriesTable waterEntries = $WaterEntriesTable(this);
  late final $WeightEntriesTable weightEntries = $WeightEntriesTable(this);
  late final $TrackedSupplementsTable trackedSupplements =
      $TrackedSupplementsTable(this);
  late final $SupplementEntriesTable supplementEntries =
      $SupplementEntriesTable(this);
  late final $SavedItemsTable savedItems = $SavedItemsTable(this);
  late final $LookupCacheEntriesTable lookupCacheEntries =
      $LookupCacheEntriesTable(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final UserDao userDao = UserDao(this as AppDatabase);
  late final PerUserTargetsDao perUserTargetsDao = PerUserTargetsDao(
    this as AppDatabase,
  );
  late final FoodEntryDao foodEntryDao = FoodEntryDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    perUserTargets,
    foodEntries,
    waterEntries,
    weightEntries,
    trackedSupplements,
    supplementEntries,
    savedItems,
    lookupCacheEntries,
    outboxEntries,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
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

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
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
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
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
      PrefetchHooks Function()
    >;
typedef $$PerUserTargetsTableCreateCompanionBuilder =
    PerUserTargetsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int?> calorieTarget,
      Value<double?> proteinTarget,
      Value<double?> fiberTarget,
      Value<double?> fruitCupsTarget,
      Value<double?> veggieCupsTarget,
      Value<double?> addedSugarLimit,
      Value<double?> carbsLimitG,
      Value<double?> fatsLimitG,
      Value<double?> waterTarget,
      Value<double?> weightTarget,
      Value<int> rowid,
    });
typedef $$PerUserTargetsTableUpdateCompanionBuilder =
    PerUserTargetsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int?> calorieTarget,
      Value<double?> proteinTarget,
      Value<double?> fiberTarget,
      Value<double?> fruitCupsTarget,
      Value<double?> veggieCupsTarget,
      Value<double?> addedSugarLimit,
      Value<double?> carbsLimitG,
      Value<double?> fatsLimitG,
      Value<double?> waterTarget,
      Value<double?> weightTarget,
      Value<int> rowid,
    });

class $$PerUserTargetsTableFilterComposer
    extends Composer<_$AppDatabase, $PerUserTargetsTable> {
  $$PerUserTargetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinTarget => $composableBuilder(
    column: $table.proteinTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberTarget => $composableBuilder(
    column: $table.fiberTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fruitCupsTarget => $composableBuilder(
    column: $table.fruitCupsTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get veggieCupsTarget => $composableBuilder(
    column: $table.veggieCupsTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get addedSugarLimit => $composableBuilder(
    column: $table.addedSugarLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsLimitG => $composableBuilder(
    column: $table.carbsLimitG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatsLimitG => $composableBuilder(
    column: $table.fatsLimitG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waterTarget => $composableBuilder(
    column: $table.waterTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightTarget => $composableBuilder(
    column: $table.weightTarget,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PerUserTargetsTableOrderingComposer
    extends Composer<_$AppDatabase, $PerUserTargetsTable> {
  $$PerUserTargetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinTarget => $composableBuilder(
    column: $table.proteinTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberTarget => $composableBuilder(
    column: $table.fiberTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fruitCupsTarget => $composableBuilder(
    column: $table.fruitCupsTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get veggieCupsTarget => $composableBuilder(
    column: $table.veggieCupsTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get addedSugarLimit => $composableBuilder(
    column: $table.addedSugarLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsLimitG => $composableBuilder(
    column: $table.carbsLimitG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatsLimitG => $composableBuilder(
    column: $table.fatsLimitG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waterTarget => $composableBuilder(
    column: $table.waterTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightTarget => $composableBuilder(
    column: $table.weightTarget,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PerUserTargetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PerUserTargetsTable> {
  $$PerUserTargetsTableAnnotationComposer({
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

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinTarget => $composableBuilder(
    column: $table.proteinTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiberTarget => $composableBuilder(
    column: $table.fiberTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fruitCupsTarget => $composableBuilder(
    column: $table.fruitCupsTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get veggieCupsTarget => $composableBuilder(
    column: $table.veggieCupsTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get addedSugarLimit => $composableBuilder(
    column: $table.addedSugarLimit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsLimitG => $composableBuilder(
    column: $table.carbsLimitG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatsLimitG => $composableBuilder(
    column: $table.fatsLimitG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get waterTarget => $composableBuilder(
    column: $table.waterTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightTarget => $composableBuilder(
    column: $table.weightTarget,
    builder: (column) => column,
  );
}

class $$PerUserTargetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PerUserTargetsTable,
          PerUserTarget,
          $$PerUserTargetsTableFilterComposer,
          $$PerUserTargetsTableOrderingComposer,
          $$PerUserTargetsTableAnnotationComposer,
          $$PerUserTargetsTableCreateCompanionBuilder,
          $$PerUserTargetsTableUpdateCompanionBuilder,
          (
            PerUserTarget,
            BaseReferences<_$AppDatabase, $PerUserTargetsTable, PerUserTarget>,
          ),
          PerUserTarget,
          PrefetchHooks Function()
        > {
  $$PerUserTargetsTableTableManager(
    _$AppDatabase db,
    $PerUserTargetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerUserTargetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerUserTargetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PerUserTargetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> calorieTarget = const Value.absent(),
                Value<double?> proteinTarget = const Value.absent(),
                Value<double?> fiberTarget = const Value.absent(),
                Value<double?> fruitCupsTarget = const Value.absent(),
                Value<double?> veggieCupsTarget = const Value.absent(),
                Value<double?> addedSugarLimit = const Value.absent(),
                Value<double?> carbsLimitG = const Value.absent(),
                Value<double?> fatsLimitG = const Value.absent(),
                Value<double?> waterTarget = const Value.absent(),
                Value<double?> weightTarget = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PerUserTargetsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                calorieTarget: calorieTarget,
                proteinTarget: proteinTarget,
                fiberTarget: fiberTarget,
                fruitCupsTarget: fruitCupsTarget,
                veggieCupsTarget: veggieCupsTarget,
                addedSugarLimit: addedSugarLimit,
                carbsLimitG: carbsLimitG,
                fatsLimitG: fatsLimitG,
                waterTarget: waterTarget,
                weightTarget: weightTarget,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String userId,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> calorieTarget = const Value.absent(),
                Value<double?> proteinTarget = const Value.absent(),
                Value<double?> fiberTarget = const Value.absent(),
                Value<double?> fruitCupsTarget = const Value.absent(),
                Value<double?> veggieCupsTarget = const Value.absent(),
                Value<double?> addedSugarLimit = const Value.absent(),
                Value<double?> carbsLimitG = const Value.absent(),
                Value<double?> fatsLimitG = const Value.absent(),
                Value<double?> waterTarget = const Value.absent(),
                Value<double?> weightTarget = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PerUserTargetsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                calorieTarget: calorieTarget,
                proteinTarget: proteinTarget,
                fiberTarget: fiberTarget,
                fruitCupsTarget: fruitCupsTarget,
                veggieCupsTarget: veggieCupsTarget,
                addedSugarLimit: addedSugarLimit,
                carbsLimitG: carbsLimitG,
                fatsLimitG: fatsLimitG,
                waterTarget: waterTarget,
                weightTarget: weightTarget,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PerUserTargetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PerUserTargetsTable,
      PerUserTarget,
      $$PerUserTargetsTableFilterComposer,
      $$PerUserTargetsTableOrderingComposer,
      $$PerUserTargetsTableAnnotationComposer,
      $$PerUserTargetsTableCreateCompanionBuilder,
      $$PerUserTargetsTableUpdateCompanionBuilder,
      (
        PerUserTarget,
        BaseReferences<_$AppDatabase, $PerUserTargetsTable, PerUserTarget>,
      ),
      PerUserTarget,
      PrefetchHooks Function()
    >;
typedef $$FoodEntriesTableCreateCompanionBuilder =
    FoodEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      required DateTime entryTimestamp,
      required double quantity,
      required FoodUnit unit,
      Value<double> calories,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatsG,
      Value<double> fiberG,
      Value<double> addedSugarG,
      Value<double> fruitCups,
      Value<double> veggieCups,
      required String name,
      required MealType mealType,
      Value<bool> isVerified,
      Value<int> rowid,
    });
typedef $$FoodEntriesTableUpdateCompanionBuilder =
    FoodEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<DateTime> entryTimestamp,
      Value<double> quantity,
      Value<FoodUnit> unit,
      Value<double> calories,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatsG,
      Value<double> fiberG,
      Value<double> addedSugarG,
      Value<double> fruitCups,
      Value<double> veggieCups,
      Value<String> name,
      Value<MealType> mealType,
      Value<bool> isVerified,
      Value<int> rowid,
    });

class $$FoodEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FoodEntriesTable> {
  $$FoodEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FoodUnit, FoodUnit, String> get unit =>
      $composableBuilder(
        column: $table.unit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatsG => $composableBuilder(
    column: $table.fatsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberG => $composableBuilder(
    column: $table.fiberG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get addedSugarG => $composableBuilder(
    column: $table.addedSugarG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fruitCups => $composableBuilder(
    column: $table.fruitCups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get veggieCups => $composableBuilder(
    column: $table.veggieCups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MealType, MealType, String> get mealType =>
      $composableBuilder(
        column: $table.mealType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodEntriesTable> {
  $$FoodEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatsG => $composableBuilder(
    column: $table.fatsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberG => $composableBuilder(
    column: $table.fiberG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get addedSugarG => $composableBuilder(
    column: $table.addedSugarG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fruitCups => $composableBuilder(
    column: $table.fruitCups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get veggieCups => $composableBuilder(
    column: $table.veggieCups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodEntriesTable> {
  $$FoodEntriesTableAnnotationComposer({
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

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FoodUnit, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatsG =>
      $composableBuilder(column: $table.fatsG, builder: (column) => column);

  GeneratedColumn<double> get fiberG =>
      $composableBuilder(column: $table.fiberG, builder: (column) => column);

  GeneratedColumn<double> get addedSugarG => $composableBuilder(
    column: $table.addedSugarG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fruitCups =>
      $composableBuilder(column: $table.fruitCups, builder: (column) => column);

  GeneratedColumn<double> get veggieCups => $composableBuilder(
    column: $table.veggieCups,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MealType, String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );
}

class $$FoodEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodEntriesTable,
          FoodEntry,
          $$FoodEntriesTableFilterComposer,
          $$FoodEntriesTableOrderingComposer,
          $$FoodEntriesTableAnnotationComposer,
          $$FoodEntriesTableCreateCompanionBuilder,
          $$FoodEntriesTableUpdateCompanionBuilder,
          (
            FoodEntry,
            BaseReferences<_$AppDatabase, $FoodEntriesTable, FoodEntry>,
          ),
          FoodEntry,
          PrefetchHooks Function()
        > {
  $$FoodEntriesTableTableManager(_$AppDatabase db, $FoodEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> entryTimestamp = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<FoodUnit> unit = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatsG = const Value.absent(),
                Value<double> fiberG = const Value.absent(),
                Value<double> addedSugarG = const Value.absent(),
                Value<double> fruitCups = const Value.absent(),
                Value<double> veggieCups = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<MealType> mealType = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                entryTimestamp: entryTimestamp,
                quantity: quantity,
                unit: unit,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatsG: fatsG,
                fiberG: fiberG,
                addedSugarG: addedSugarG,
                fruitCups: fruitCups,
                veggieCups: veggieCups,
                name: name,
                mealType: mealType,
                isVerified: isVerified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String userId,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                required DateTime entryTimestamp,
                required double quantity,
                required FoodUnit unit,
                Value<double> calories = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatsG = const Value.absent(),
                Value<double> fiberG = const Value.absent(),
                Value<double> addedSugarG = const Value.absent(),
                Value<double> fruitCups = const Value.absent(),
                Value<double> veggieCups = const Value.absent(),
                required String name,
                required MealType mealType,
                Value<bool> isVerified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                entryTimestamp: entryTimestamp,
                quantity: quantity,
                unit: unit,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatsG: fatsG,
                fiberG: fiberG,
                addedSugarG: addedSugarG,
                fruitCups: fruitCups,
                veggieCups: veggieCups,
                name: name,
                mealType: mealType,
                isVerified: isVerified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodEntriesTable,
      FoodEntry,
      $$FoodEntriesTableFilterComposer,
      $$FoodEntriesTableOrderingComposer,
      $$FoodEntriesTableAnnotationComposer,
      $$FoodEntriesTableCreateCompanionBuilder,
      $$FoodEntriesTableUpdateCompanionBuilder,
      (FoodEntry, BaseReferences<_$AppDatabase, $FoodEntriesTable, FoodEntry>),
      FoodEntry,
      PrefetchHooks Function()
    >;
typedef $$WaterEntriesTableCreateCompanionBuilder =
    WaterEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      required DateTime entryTimestamp,
      required double amount,
      Value<int> rowid,
    });
typedef $$WaterEntriesTableUpdateCompanionBuilder =
    WaterEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<DateTime> entryTimestamp,
      Value<double> amount,
      Value<int> rowid,
    });

class $$WaterEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WaterEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WaterEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableAnnotationComposer({
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

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);
}

class $$WaterEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterEntriesTable,
          WaterEntry,
          $$WaterEntriesTableFilterComposer,
          $$WaterEntriesTableOrderingComposer,
          $$WaterEntriesTableAnnotationComposer,
          $$WaterEntriesTableCreateCompanionBuilder,
          $$WaterEntriesTableUpdateCompanionBuilder,
          (
            WaterEntry,
            BaseReferences<_$AppDatabase, $WaterEntriesTable, WaterEntry>,
          ),
          WaterEntry,
          PrefetchHooks Function()
        > {
  $$WaterEntriesTableTableManager(_$AppDatabase db, $WaterEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> entryTimestamp = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WaterEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                entryTimestamp: entryTimestamp,
                amount: amount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String userId,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                required DateTime entryTimestamp,
                required double amount,
                Value<int> rowid = const Value.absent(),
              }) => WaterEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                entryTimestamp: entryTimestamp,
                amount: amount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WaterEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterEntriesTable,
      WaterEntry,
      $$WaterEntriesTableFilterComposer,
      $$WaterEntriesTableOrderingComposer,
      $$WaterEntriesTableAnnotationComposer,
      $$WaterEntriesTableCreateCompanionBuilder,
      $$WaterEntriesTableUpdateCompanionBuilder,
      (
        WaterEntry,
        BaseReferences<_$AppDatabase, $WaterEntriesTable, WaterEntry>,
      ),
      WaterEntry,
      PrefetchHooks Function()
    >;
typedef $$WeightEntriesTableCreateCompanionBuilder =
    WeightEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      required DateTime entryTimestamp,
      required double weight,
      Value<int> rowid,
    });
typedef $$WeightEntriesTableUpdateCompanionBuilder =
    WeightEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<DateTime> entryTimestamp,
      Value<double> weight,
      Value<int> rowid,
    });

class $$WeightEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableAnnotationComposer({
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

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);
}

class $$WeightEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightEntriesTable,
          WeightEntry,
          $$WeightEntriesTableFilterComposer,
          $$WeightEntriesTableOrderingComposer,
          $$WeightEntriesTableAnnotationComposer,
          $$WeightEntriesTableCreateCompanionBuilder,
          $$WeightEntriesTableUpdateCompanionBuilder,
          (
            WeightEntry,
            BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry>,
          ),
          WeightEntry,
          PrefetchHooks Function()
        > {
  $$WeightEntriesTableTableManager(_$AppDatabase db, $WeightEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> entryTimestamp = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                entryTimestamp: entryTimestamp,
                weight: weight,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String userId,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                required DateTime entryTimestamp,
                required double weight,
                Value<int> rowid = const Value.absent(),
              }) => WeightEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                entryTimestamp: entryTimestamp,
                weight: weight,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightEntriesTable,
      WeightEntry,
      $$WeightEntriesTableFilterComposer,
      $$WeightEntriesTableOrderingComposer,
      $$WeightEntriesTableAnnotationComposer,
      $$WeightEntriesTableCreateCompanionBuilder,
      $$WeightEntriesTableUpdateCompanionBuilder,
      (
        WeightEntry,
        BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry>,
      ),
      WeightEntry,
      PrefetchHooks Function()
    >;
typedef $$TrackedSupplementsTableCreateCompanionBuilder =
    TrackedSupplementsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      required String name,
      required SupplementType type,
      Value<int?> dailyTargetCount,
      Value<int> rowid,
    });
typedef $$TrackedSupplementsTableUpdateCompanionBuilder =
    TrackedSupplementsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<String> name,
      Value<SupplementType> type,
      Value<int?> dailyTargetCount,
      Value<int> rowid,
    });

final class $$TrackedSupplementsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TrackedSupplementsTable,
          TrackedSupplement
        > {
  $$TrackedSupplementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SupplementEntriesTable, List<SupplementEntry>>
  _supplementEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.supplementEntries,
        aliasName: $_aliasNameGenerator(
          db.trackedSupplements.id,
          db.supplementEntries.supplementId,
        ),
      );

  $$SupplementEntriesTableProcessedTableManager get supplementEntriesRefs {
    final manager = $$SupplementEntriesTableTableManager(
      $_db,
      $_db.supplementEntries,
    ).filter((f) => f.supplementId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _supplementEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TrackedSupplementsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackedSupplementsTable> {
  $$TrackedSupplementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SupplementType, SupplementType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get dailyTargetCount => $composableBuilder(
    column: $table.dailyTargetCount,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> supplementEntriesRefs(
    Expression<bool> Function($$SupplementEntriesTableFilterComposer f) f,
  ) {
    final $$SupplementEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.supplementEntries,
      getReferencedColumn: (t) => t.supplementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplementEntriesTableFilterComposer(
            $db: $db,
            $table: $db.supplementEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrackedSupplementsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackedSupplementsTable> {
  $$TrackedSupplementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyTargetCount => $composableBuilder(
    column: $table.dailyTargetCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrackedSupplementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackedSupplementsTable> {
  $$TrackedSupplementsTableAnnotationComposer({
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

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SupplementType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get dailyTargetCount => $composableBuilder(
    column: $table.dailyTargetCount,
    builder: (column) => column,
  );

  Expression<T> supplementEntriesRefs<T extends Object>(
    Expression<T> Function($$SupplementEntriesTableAnnotationComposer a) f,
  ) {
    final $$SupplementEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.supplementEntries,
          getReferencedColumn: (t) => t.supplementId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SupplementEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.supplementEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TrackedSupplementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackedSupplementsTable,
          TrackedSupplement,
          $$TrackedSupplementsTableFilterComposer,
          $$TrackedSupplementsTableOrderingComposer,
          $$TrackedSupplementsTableAnnotationComposer,
          $$TrackedSupplementsTableCreateCompanionBuilder,
          $$TrackedSupplementsTableUpdateCompanionBuilder,
          (TrackedSupplement, $$TrackedSupplementsTableReferences),
          TrackedSupplement,
          PrefetchHooks Function({bool supplementEntriesRefs})
        > {
  $$TrackedSupplementsTableTableManager(
    _$AppDatabase db,
    $TrackedSupplementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackedSupplementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackedSupplementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackedSupplementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<SupplementType> type = const Value.absent(),
                Value<int?> dailyTargetCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackedSupplementsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                name: name,
                type: type,
                dailyTargetCount: dailyTargetCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String userId,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String name,
                required SupplementType type,
                Value<int?> dailyTargetCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackedSupplementsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                name: name,
                type: type,
                dailyTargetCount: dailyTargetCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackedSupplementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({supplementEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (supplementEntriesRefs) db.supplementEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (supplementEntriesRefs)
                    await $_getPrefetchedData<
                      TrackedSupplement,
                      $TrackedSupplementsTable,
                      SupplementEntry
                    >(
                      currentTable: table,
                      referencedTable: $$TrackedSupplementsTableReferences
                          ._supplementEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TrackedSupplementsTableReferences(
                            db,
                            table,
                            p0,
                          ).supplementEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.supplementId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TrackedSupplementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackedSupplementsTable,
      TrackedSupplement,
      $$TrackedSupplementsTableFilterComposer,
      $$TrackedSupplementsTableOrderingComposer,
      $$TrackedSupplementsTableAnnotationComposer,
      $$TrackedSupplementsTableCreateCompanionBuilder,
      $$TrackedSupplementsTableUpdateCompanionBuilder,
      (TrackedSupplement, $$TrackedSupplementsTableReferences),
      TrackedSupplement,
      PrefetchHooks Function({bool supplementEntriesRefs})
    >;
typedef $$SupplementEntriesTableCreateCompanionBuilder =
    SupplementEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      required DateTime entryTimestamp,
      required String supplementId,
      Value<int> rowid,
    });
typedef $$SupplementEntriesTableUpdateCompanionBuilder =
    SupplementEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<DateTime> entryTimestamp,
      Value<String> supplementId,
      Value<int> rowid,
    });

final class $$SupplementEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SupplementEntriesTable,
          SupplementEntry
        > {
  $$SupplementEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TrackedSupplementsTable _supplementIdTable(_$AppDatabase db) =>
      db.trackedSupplements.createAlias(
        $_aliasNameGenerator(
          db.supplementEntries.supplementId,
          db.trackedSupplements.id,
        ),
      );

  $$TrackedSupplementsTableProcessedTableManager get supplementId {
    final $_column = $_itemColumn<String>('supplement_id')!;

    final manager = $$TrackedSupplementsTableTableManager(
      $_db,
      $_db.trackedSupplements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SupplementEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementEntriesTable> {
  $$SupplementEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$TrackedSupplementsTableFilterComposer get supplementId {
    final $$TrackedSupplementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplementId,
      referencedTable: $db.trackedSupplements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackedSupplementsTableFilterComposer(
            $db: $db,
            $table: $db.trackedSupplements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupplementEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementEntriesTable> {
  $$SupplementEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrackedSupplementsTableOrderingComposer get supplementId {
    final $$TrackedSupplementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplementId,
      referencedTable: $db.trackedSupplements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackedSupplementsTableOrderingComposer(
            $db: $db,
            $table: $db.trackedSupplements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupplementEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementEntriesTable> {
  $$SupplementEntriesTableAnnotationComposer({
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

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get entryTimestamp => $composableBuilder(
    column: $table.entryTimestamp,
    builder: (column) => column,
  );

  $$TrackedSupplementsTableAnnotationComposer get supplementId {
    final $$TrackedSupplementsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.supplementId,
          referencedTable: $db.trackedSupplements,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TrackedSupplementsTableAnnotationComposer(
                $db: $db,
                $table: $db.trackedSupplements,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SupplementEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementEntriesTable,
          SupplementEntry,
          $$SupplementEntriesTableFilterComposer,
          $$SupplementEntriesTableOrderingComposer,
          $$SupplementEntriesTableAnnotationComposer,
          $$SupplementEntriesTableCreateCompanionBuilder,
          $$SupplementEntriesTableUpdateCompanionBuilder,
          (SupplementEntry, $$SupplementEntriesTableReferences),
          SupplementEntry,
          PrefetchHooks Function({bool supplementId})
        > {
  $$SupplementEntriesTableTableManager(
    _$AppDatabase db,
    $SupplementEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplementEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplementEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> entryTimestamp = const Value.absent(),
                Value<String> supplementId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplementEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                entryTimestamp: entryTimestamp,
                supplementId: supplementId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String userId,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                required DateTime entryTimestamp,
                required String supplementId,
                Value<int> rowid = const Value.absent(),
              }) => SupplementEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                entryTimestamp: entryTimestamp,
                supplementId: supplementId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SupplementEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({supplementId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (supplementId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.supplementId,
                                referencedTable:
                                    $$SupplementEntriesTableReferences
                                        ._supplementIdTable(db),
                                referencedColumn:
                                    $$SupplementEntriesTableReferences
                                        ._supplementIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SupplementEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementEntriesTable,
      SupplementEntry,
      $$SupplementEntriesTableFilterComposer,
      $$SupplementEntriesTableOrderingComposer,
      $$SupplementEntriesTableAnnotationComposer,
      $$SupplementEntriesTableCreateCompanionBuilder,
      $$SupplementEntriesTableUpdateCompanionBuilder,
      (SupplementEntry, $$SupplementEntriesTableReferences),
      SupplementEntry,
      PrefetchHooks Function({bool supplementId})
    >;
typedef $$SavedItemsTableCreateCompanionBuilder =
    SavedItemsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      required double quantity,
      required FoodUnit unit,
      Value<double> calories,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatsG,
      Value<double> fiberG,
      Value<double> addedSugarG,
      Value<double> fruitCups,
      Value<double> veggieCups,
      required String name,
      Value<int> rowid,
    });
typedef $$SavedItemsTableUpdateCompanionBuilder =
    SavedItemsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> userId,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<double> quantity,
      Value<FoodUnit> unit,
      Value<double> calories,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatsG,
      Value<double> fiberG,
      Value<double> addedSugarG,
      Value<double> fruitCups,
      Value<double> veggieCups,
      Value<String> name,
      Value<int> rowid,
    });

class $$SavedItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedItemsTable> {
  $$SavedItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FoodUnit, FoodUnit, String> get unit =>
      $composableBuilder(
        column: $table.unit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatsG => $composableBuilder(
    column: $table.fatsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberG => $composableBuilder(
    column: $table.fiberG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get addedSugarG => $composableBuilder(
    column: $table.addedSugarG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fruitCups => $composableBuilder(
    column: $table.fruitCups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get veggieCups => $composableBuilder(
    column: $table.veggieCups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedItemsTable> {
  $$SavedItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatsG => $composableBuilder(
    column: $table.fatsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberG => $composableBuilder(
    column: $table.fiberG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get addedSugarG => $composableBuilder(
    column: $table.addedSugarG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fruitCups => $composableBuilder(
    column: $table.fruitCups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get veggieCups => $composableBuilder(
    column: $table.veggieCups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedItemsTable> {
  $$SavedItemsTableAnnotationComposer({
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

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FoodUnit, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatsG =>
      $composableBuilder(column: $table.fatsG, builder: (column) => column);

  GeneratedColumn<double> get fiberG =>
      $composableBuilder(column: $table.fiberG, builder: (column) => column);

  GeneratedColumn<double> get addedSugarG => $composableBuilder(
    column: $table.addedSugarG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fruitCups =>
      $composableBuilder(column: $table.fruitCups, builder: (column) => column);

  GeneratedColumn<double> get veggieCups => $composableBuilder(
    column: $table.veggieCups,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$SavedItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedItemsTable,
          SavedItem,
          $$SavedItemsTableFilterComposer,
          $$SavedItemsTableOrderingComposer,
          $$SavedItemsTableAnnotationComposer,
          $$SavedItemsTableCreateCompanionBuilder,
          $$SavedItemsTableUpdateCompanionBuilder,
          (
            SavedItem,
            BaseReferences<_$AppDatabase, $SavedItemsTable, SavedItem>,
          ),
          SavedItem,
          PrefetchHooks Function()
        > {
  $$SavedItemsTableTableManager(_$AppDatabase db, $SavedItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<FoodUnit> unit = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatsG = const Value.absent(),
                Value<double> fiberG = const Value.absent(),
                Value<double> addedSugarG = const Value.absent(),
                Value<double> fruitCups = const Value.absent(),
                Value<double> veggieCups = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedItemsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                quantity: quantity,
                unit: unit,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatsG: fatsG,
                fiberG: fiberG,
                addedSugarG: addedSugarG,
                fruitCups: fruitCups,
                veggieCups: veggieCups,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String userId,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                required double quantity,
                required FoodUnit unit,
                Value<double> calories = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatsG = const Value.absent(),
                Value<double> fiberG = const Value.absent(),
                Value<double> addedSugarG = const Value.absent(),
                Value<double> fruitCups = const Value.absent(),
                Value<double> veggieCups = const Value.absent(),
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => SavedItemsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                deletedAt: deletedAt,
                version: version,
                quantity: quantity,
                unit: unit,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatsG: fatsG,
                fiberG: fiberG,
                addedSugarG: addedSugarG,
                fruitCups: fruitCups,
                veggieCups: veggieCups,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedItemsTable,
      SavedItem,
      $$SavedItemsTableFilterComposer,
      $$SavedItemsTableOrderingComposer,
      $$SavedItemsTableAnnotationComposer,
      $$SavedItemsTableCreateCompanionBuilder,
      $$SavedItemsTableUpdateCompanionBuilder,
      (SavedItem, BaseReferences<_$AppDatabase, $SavedItemsTable, SavedItem>),
      SavedItem,
      PrefetchHooks Function()
    >;
typedef $$LookupCacheEntriesTableCreateCompanionBuilder =
    LookupCacheEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String userId,
      required double quantity,
      required FoodUnit unit,
      Value<double> calories,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatsG,
      Value<double> fiberG,
      Value<double> addedSugarG,
      Value<double> fruitCups,
      Value<double> veggieCups,
      required String name,
      Value<String?> sourceRef,
      Value<int> useCount,
      Value<DateTime> lastUsedAt,
      Value<int> rowid,
    });
typedef $$LookupCacheEntriesTableUpdateCompanionBuilder =
    LookupCacheEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> userId,
      Value<double> quantity,
      Value<FoodUnit> unit,
      Value<double> calories,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatsG,
      Value<double> fiberG,
      Value<double> addedSugarG,
      Value<double> fruitCups,
      Value<double> veggieCups,
      Value<String> name,
      Value<String?> sourceRef,
      Value<int> useCount,
      Value<DateTime> lastUsedAt,
      Value<int> rowid,
    });

class $$LookupCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LookupCacheEntriesTable> {
  $$LookupCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FoodUnit, FoodUnit, String> get unit =>
      $composableBuilder(
        column: $table.unit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatsG => $composableBuilder(
    column: $table.fatsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberG => $composableBuilder(
    column: $table.fiberG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get addedSugarG => $composableBuilder(
    column: $table.addedSugarG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fruitCups => $composableBuilder(
    column: $table.fruitCups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get veggieCups => $composableBuilder(
    column: $table.veggieCups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LookupCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LookupCacheEntriesTable> {
  $$LookupCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatsG => $composableBuilder(
    column: $table.fatsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberG => $composableBuilder(
    column: $table.fiberG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get addedSugarG => $composableBuilder(
    column: $table.addedSugarG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fruitCups => $composableBuilder(
    column: $table.fruitCups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get veggieCups => $composableBuilder(
    column: $table.veggieCups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LookupCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LookupCacheEntriesTable> {
  $$LookupCacheEntriesTableAnnotationComposer({
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

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FoodUnit, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatsG =>
      $composableBuilder(column: $table.fatsG, builder: (column) => column);

  GeneratedColumn<double> get fiberG =>
      $composableBuilder(column: $table.fiberG, builder: (column) => column);

  GeneratedColumn<double> get addedSugarG => $composableBuilder(
    column: $table.addedSugarG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fruitCups =>
      $composableBuilder(column: $table.fruitCups, builder: (column) => column);

  GeneratedColumn<double> get veggieCups => $composableBuilder(
    column: $table.veggieCups,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sourceRef =>
      $composableBuilder(column: $table.sourceRef, builder: (column) => column);

  GeneratedColumn<int> get useCount =>
      $composableBuilder(column: $table.useCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );
}

class $$LookupCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LookupCacheEntriesTable,
          LookupCacheEntry,
          $$LookupCacheEntriesTableFilterComposer,
          $$LookupCacheEntriesTableOrderingComposer,
          $$LookupCacheEntriesTableAnnotationComposer,
          $$LookupCacheEntriesTableCreateCompanionBuilder,
          $$LookupCacheEntriesTableUpdateCompanionBuilder,
          (
            LookupCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $LookupCacheEntriesTable,
              LookupCacheEntry
            >,
          ),
          LookupCacheEntry,
          PrefetchHooks Function()
        > {
  $$LookupCacheEntriesTableTableManager(
    _$AppDatabase db,
    $LookupCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LookupCacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LookupCacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LookupCacheEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<FoodUnit> unit = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatsG = const Value.absent(),
                Value<double> fiberG = const Value.absent(),
                Value<double> addedSugarG = const Value.absent(),
                Value<double> fruitCups = const Value.absent(),
                Value<double> veggieCups = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> sourceRef = const Value.absent(),
                Value<int> useCount = const Value.absent(),
                Value<DateTime> lastUsedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LookupCacheEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                quantity: quantity,
                unit: unit,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatsG: fatsG,
                fiberG: fiberG,
                addedSugarG: addedSugarG,
                fruitCups: fruitCups,
                veggieCups: veggieCups,
                name: name,
                sourceRef: sourceRef,
                useCount: useCount,
                lastUsedAt: lastUsedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String userId,
                required double quantity,
                required FoodUnit unit,
                Value<double> calories = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatsG = const Value.absent(),
                Value<double> fiberG = const Value.absent(),
                Value<double> addedSugarG = const Value.absent(),
                Value<double> fruitCups = const Value.absent(),
                Value<double> veggieCups = const Value.absent(),
                required String name,
                Value<String?> sourceRef = const Value.absent(),
                Value<int> useCount = const Value.absent(),
                Value<DateTime> lastUsedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LookupCacheEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                userId: userId,
                quantity: quantity,
                unit: unit,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatsG: fatsG,
                fiberG: fiberG,
                addedSugarG: addedSugarG,
                fruitCups: fruitCups,
                veggieCups: veggieCups,
                name: name,
                sourceRef: sourceRef,
                useCount: useCount,
                lastUsedAt: lastUsedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LookupCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LookupCacheEntriesTable,
      LookupCacheEntry,
      $$LookupCacheEntriesTableFilterComposer,
      $$LookupCacheEntriesTableOrderingComposer,
      $$LookupCacheEntriesTableAnnotationComposer,
      $$LookupCacheEntriesTableCreateCompanionBuilder,
      $$LookupCacheEntriesTableUpdateCompanionBuilder,
      (
        LookupCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $LookupCacheEntriesTable,
          LookupCacheEntry
        >,
      ),
      LookupCacheEntry,
      PrefetchHooks Function()
    >;
typedef $$OutboxEntriesTableCreateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<String> id,
      required String entityType,
      required String entityId,
      required SyncOperation operation,
      Value<DateTime> queuedAt,
      Value<int> retryCount,
      Value<DateTime?> lastAttemptAt,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$OutboxEntriesTableUpdateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<SyncOperation> operation,
      Value<DateTime> queuedAt,
      Value<int> retryCount,
      Value<DateTime?> lastAttemptAt,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$OutboxEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncOperation, SyncOperation, String>
  get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncOperation, String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<DateTime> get queuedAt =>
      $composableBuilder(column: $table.queuedAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$OutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxEntriesTable,
          OutboxEntry,
          $$OutboxEntriesTableFilterComposer,
          $$OutboxEntriesTableOrderingComposer,
          $$OutboxEntriesTableAnnotationComposer,
          $$OutboxEntriesTableCreateCompanionBuilder,
          $$OutboxEntriesTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxEntriesTableTableManager(_$AppDatabase db, $OutboxEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<SyncOperation> operation = const Value.absent(),
                Value<DateTime> queuedAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxEntriesCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                queuedAt: queuedAt,
                retryCount: retryCount,
                lastAttemptAt: lastAttemptAt,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String entityType,
                required String entityId,
                required SyncOperation operation,
                Value<DateTime> queuedAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxEntriesCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                queuedAt: queuedAt,
                retryCount: retryCount,
                lastAttemptAt: lastAttemptAt,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxEntriesTable,
      OutboxEntry,
      $$OutboxEntriesTableFilterComposer,
      $$OutboxEntriesTableOrderingComposer,
      $$OutboxEntriesTableAnnotationComposer,
      $$OutboxEntriesTableCreateCompanionBuilder,
      $$OutboxEntriesTableUpdateCompanionBuilder,
      (
        OutboxEntry,
        BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
      ),
      OutboxEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$PerUserTargetsTableTableManager get perUserTargets =>
      $$PerUserTargetsTableTableManager(_db, _db.perUserTargets);
  $$FoodEntriesTableTableManager get foodEntries =>
      $$FoodEntriesTableTableManager(_db, _db.foodEntries);
  $$WaterEntriesTableTableManager get waterEntries =>
      $$WaterEntriesTableTableManager(_db, _db.waterEntries);
  $$WeightEntriesTableTableManager get weightEntries =>
      $$WeightEntriesTableTableManager(_db, _db.weightEntries);
  $$TrackedSupplementsTableTableManager get trackedSupplements =>
      $$TrackedSupplementsTableTableManager(_db, _db.trackedSupplements);
  $$SupplementEntriesTableTableManager get supplementEntries =>
      $$SupplementEntriesTableTableManager(_db, _db.supplementEntries);
  $$SavedItemsTableTableManager get savedItems =>
      $$SavedItemsTableTableManager(_db, _db.savedItems);
  $$LookupCacheEntriesTableTableManager get lookupCacheEntries =>
      $$LookupCacheEntriesTableTableManager(_db, _db.lookupCacheEntries);
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
}
