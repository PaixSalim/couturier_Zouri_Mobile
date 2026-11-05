# Dev Couturier — application mobile (Flutter)

Application de l'atelier pour l'API Dev Couturier : clients, relevés de mesures,
catalogue, commandes, encaissements et notifications. Elle fonctionne hors ligne
(base SQLite locale via Drift) et se synchronise avec le serveur dès que le réseau
revient.

## Lancer

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://IP_DU_SERVEUR:8000
```

Sans `API_BASE_URL`, l'appli vise `http://10.0.2.2:8000` (backend local vu depuis
l'émulateur Android) ou `http://localhost:8000` en version web. L'adresse se change
aussi dans Réglages › Synchronisation. En debug, Android autorise le HTTP non chiffré.

## Synchronisation

- Connexion JWT (`/api/v1/auth/token/`), renouvellement automatique du jeton.
- Premier atelier de l'utilisateur, ou création d'un atelier s'il n'en a aucun.
- Envoi dans l'ordre clients → mesures → modèles → commandes → paiements ;
  commandes et paiements portent leur identifiant local en `client_request_id`
  (pas de doublon après une coupure).
- Récupération de ce qui a été saisi sur le serveur ; une modification locale pas
  encore envoyée n'est jamais écrasée.
- Paiements : les espèces sont confirmées tout de suite, les autres modes restent en
  attente jusqu'à « Argent reçu » (confirmation réservée aux responsables côté API).

## Tests

```bash
flutter test
```

Les tests de synchronisation tournent contre un faux serveur qui imite l'API ; un
test vérifie la migration de la base locale.

## Version web

`flutter build web` produit une version navigateur (SQLite en WebAssembly :
`web/sqlite3.wasm` et `web/drift_worker.js`, aux versions de `pubspec.lock`).
