--
-- Copyright 2004-2017 Entrust. All rights reserved.
--
-- This file defines the database schema used to upgrade Entrust IdentityGuard
-- from 10.2 to 12.0

  ALTER TABLE partitions change partition entpartition mediumblob;
  ALTER TABLE partitions rename to entpartitions;

  ALTER TABLE smartcredentials ADD
  (
    mobilelicense SMALLINT DEFAULT NULL,
    idassuredlicense SMALLINT DEFAULT NULL,
    registered SMALLINT DEFAULT NULL,
    serverside SMALLINT DEFAULT NULL
  );

  ALTER TABLE tokens ADD
  (
    mobilelicense SMALLINT DEFAULT NULL,
    tvslicense SMALLINT DEFAULT NULL,
    teelicense SMALLINT DEFAULT NULL
  );

  ALTER TABLE digitalids ADD
  (
    dn VARCHAR(255) DEFAULT NULL
  );

  ALTER TABLE users ADD
  (
    biometrics mediumblob DEFAULT NULL,
    sync_orphaned integer DEFAULT 0 NOT NULL,
    sync_unique_id VARCHAR(255) DEFAULT NULL,
    pvn_expiredate DATETIME DEFAULT NULL
  );

  CREATE INDEX users_syncuid_index ON users (sync_unique_id);

  CREATE TABLE biometrics
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    vendorid VARCHAR(100) NOT NULL,
    state VARCHAR(20) NOT NULL,
    enroll_state VARCHAR(20) NOT NULL,
    enroll_date DATETIME NOT NULL,
    lastused_date DATETIME NOT NULL,
    CONSTRAINT userbiometrics_pkey PRIMARY KEY (group_id, user_id, vendorid),
    CONSTRAINT user_biometric_key FOREIGN KEY (group_id, user_id) 
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;

  CREATE TABLE anonymous_challenges
  (
    anon_challenge_data mediumblob,
    create_date DATETIME NOT NULL,
    sernum DECIMAL(12, 0) NOT NULL,
    group_id integer DEFAULT 0 NOT NULL,
    transaction_id VARCHAR(255),
    CONSTRAINT anon_challenge_pkey PRIMARY KEY (sernum)
  ) ENGINE=InnoDB;

