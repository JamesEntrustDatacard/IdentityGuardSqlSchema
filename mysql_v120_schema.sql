--
-- Copyright 2004-2017 Entrust. All rights reserved.
--
-- This file defines the database schema used by Entrust IdentityGuard 12.0


  CREATE TABLE users
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    user_number integer NOT NULL,
    lockout_count integer NOT NULL,
    lockout_expiry DATETIME NOT NULL,
    user_info mediumblob NOT NULL,
    temporary_pin mediumblob,
    cards mediumblob,
    tokens mediumblob,
    certificates mediumblob DEFAULT NULL,
    auth_secrets mediumblob,
    federations mediumblob DEFAULT NULL,
    digitalids mediumblob DEFAULT NULL,
    smartcredentials mediumblob DEFAULT NULL,
    smartcredentialblobs mediumblob DEFAULT NULL,
    biometrics mediumblob DEFAULT NULL,
    user_state VARCHAR(255) NOT NULL,
    activation_expiry DATETIME,
    pvn_state integer DEFAULT 0 NOT NULL,
    password_state VARCHAR(255) DEFAULT NULL,
    password_expdate DATETIME DEFAULT NULL,
    num_qa integer DEFAULT 0 NOT NULL,
    num_reg_machines integer DEFAULT 0 NOT NULL,
    num_temp_pin_uses integer DEFAULT 0 NOT NULL,
    temppin_expdate DATETIME DEFAULT NULL,
    otp_allowed integer DEFAULT 1 NOT NULL,
    otp_delivery VARCHAR(255) NOT NULL,
    num_cinfo integer DEFAULT 0 NOT NULL,
    num_usable_cinfo integer DEFAULT 0 NOT NULL,
    pvn_lastchangedate DATETIME DEFAULT NULL,
    num_locations integer DEFAULT 0 NOT NULL,
    num_otps integer DEFAULT NULL,
    otp_expdate DATETIME DEFAULT NULL,
    psswd_lastchngdate DATETIME DEFAULT NULL,
    fullname VARCHAR(255),
    partition_id integer DEFAULT NULL,
    lastauthdate DATETIME DEFAULT NULL,
    lastauthtype VARCHAR(20) DEFAULT NULL,
    lastfailedauthdate DATETIME DEFAULT NULL,
    lastfailedauthtype VARCHAR(20) DEFAULT NULL,
    locale VARCHAR(20) DEFAULT NULL,
    sync_orphaned integer DEFAULT 0 NOT NULL,
    sync_unique_id VARCHAR(255) DEFAULT NULL,
    pvn_expiredate DATETIME DEFAULT NULL,
    CONSTRAINT user_id_key PRIMARY KEY (group_id, user_id)
  ) ENGINE=InnoDB;


  CREATE UNIQUE INDEX users_user_number_index ON users (user_number);
  CREATE INDEX users_username_index ON users (user_id);
  CREATE INDEX users_syncuid_index ON users (sync_unique_id);

  CREATE TABLE cards
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    serial_number VARCHAR(255) NOT NULL,
    card_state VARCHAR(255) NOT NULL,
    generate_date DATETIME NOT NULL,
    expiry_date DATETIME NOT NULL,
    challenge_count integer,
    least_used_cell_usage_count integer,
    card_usage_threshold_indicator VARCHAR(255),
    CONSTRAINT cards_pkey PRIMARY KEY (serial_number),
    CONSTRAINT User_key FOREIGN KEY (group_id, user_id) 
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;

  CREATE INDEX card_user_id_index ON cards (group_id, user_id);
  
  CREATE TABLE tokens
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    vendorid VARCHAR(100) NOT NULL,
    serial_number VARCHAR(255) NOT NULL,
    token_state VARCHAR(255) NOT NULL,
    load_date DATETIME NOT NULL,
    lastused_date DATETIME NOT NULL,
    mobilelicense SMALLINT DEFAULT NULL,
    tvslicense SMALLINT DEFAULT NULL,
    teelicense SMALLINT DEFAULT NULL,
    CONSTRAINT usertokens_pkey PRIMARY KEY (vendorid, serial_number),
    CONSTRAINT token_user_key FOREIGN KEY (group_id, user_id) 
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;

  CREATE INDEX token_user_id_index ON tokens (group_id, user_id);

  CREATE TABLE certificates
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    issuerdn_hash VARCHAR(100) NOT NULL,
    issuerdn VARCHAR(512) NOT NULL,
    subjectdn VARCHAR(512) NOT NULL,
    serial_number VARCHAR(50) NOT NULL,
    certificate_state VARCHAR(20) NOT NULL,
    ca INTEGER NOT NULL,
    issue_date DATETIME NOT NULL,
    expiry_date DATETIME NOT NULL,
    assign_date DATETIME NOT NULL,
    lastused_date DATETIME NOT NULL,
    CONSTRAINT usercerts_pkey PRIMARY KEY (issuerdn_hash, serial_number),
    CONSTRAINT cert_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;

  CREATE INDEX cert_user_id_index ON certificates (group_id, user_id);
  
  CREATE TABLE aliases
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    alias   VARCHAR(255) NOT NULL,
    CONSTRAINT alias_pkey PRIMARY KEY (group_id, alias) ,
    CONSTRAINT aliases_User_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;

  CREATE INDEX alias_user_id_index ON aliases (group_id, user_id);
  CREATE INDEX alias_username_index ON aliases (user_id);

  CREATE TABLE challenges
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    challenge mediumblob,
    CONSTRAINT challenges_pkey PRIMARY KEY (group_id, user_id),
    CONSTRAINT challenges_User_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;

  CREATE TABLE user_roles
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    role_id INTEGER NOT NULL,
    CONSTRAINT user_role_pkey PRIMARY KEY (group_id, user_id, role_id),
    CONSTRAINT user_role_user_fkey FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;

  CREATE TABLE globalpolicy
  (
    policy mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT globalpolicy_pkey PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE entpartitions
  (
    entpartition mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT partition_id PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE policy
  (
    policy mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT policy_id PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE policy_cardspec
  (
    cardspec mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT cardspec_id PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE policy_passwordpolicy
  (
    passwordpolicy mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT passwordpolicy_key PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE policy_temppinspec
  (
    temppinspec mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT temppinspec_id PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE policy_userspec
  (
    userspec mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT userspec_id PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE ipblacklist
  (
    ipblacklist mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT ipblacklist_id PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE roles
  (
    role_data mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT roles_pkey PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE groups
  (
    group_data mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT groups_pkey PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE smartcredential_printmodules
  (
    smartcredential_printmodules mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT printmodules_pkey PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE smartcredential_definitions
  (
    smartcredential_definitions mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT definition_pkey PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE smartcredential_applets
  (
    smartcredential_applets mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT applet_pkey PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE smartcredential_graphics
  (
    smartcredential_graphics mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT graphic_pkey PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE smartcredential_layouts
  (
    smartcredential_layouts mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT layout_pkey PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE digitalid_configs
  (
    digitalid_configs mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT digitialid_config_pkey PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE pacs
  (
    pacs mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT pacs_pkey PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE proxys
  (
    proxys mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT proxy_pkey PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE preproduced_cards
  (
     card_data mediumblob,
     create_date DATETIME NOT NULL,
     sernum DECIMAL(12, 0) NOT NULL,
     group_id integer DEFAULT 0 NOT NULL,
     CONSTRAINT preprod_pkey PRIMARY KEY (sernum)
  ) ENGINE=InnoDB;

  CREATE TABLE unassigned_tokens
  (
     token_data mediumblob,
     load_date DATETIME NOT NULL,
     vendorid VARCHAR(100) NOT NULL,
     sernum VARCHAR(255) NOT NULL,
     group_id integer NOT NULL,
     CONSTRAINT token_pkey PRIMARY KEY (vendorid, sernum)
  ) ENGINE=InnoDB;

  CREATE TABLE unassigned_smartcredentials
  (
     smartcredential_data mediumblob,
     load_date DATETIME NOT NULL,
     sernum VARCHAR(255) NOT NULL,
     state VARCHAR(40) NOT NULL,
     group_id integer NOT NULL,
     carduid VARCHAR(20),
     CONSTRAINT unassigned_sc_pkey PRIMARY KEY (sernum)
  ) ENGINE=InnoDB;
  CREATE INDEX usc_carduid_index ON unassigned_smartcredentials (carduid);

  CREATE TABLE transcerts
  (
    transcerts mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT transcerts_id PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE audits
  (
     audit_seqno      BIGINT AUTO_INCREMENT PRIMARY KEY,
     audit_date       DATETIME,
     audit_host       VARCHAR(255),
     audit_level      VARCHAR(10),
     audit_code       INTEGER,
     admin_group      VARCHAR(255),
     admin_name       VARCHAR(255),
     target_type      VARCHAR(20),
     target_op        VARCHAR(20),
     target_group     VARCHAR(255),
     target_name      VARCHAR(255),
     target_subname   VARCHAR(255),
     audit_service    VARCHAR(20),
     external_code    VARCHAR(20),
     external_service VARCHAR(255),
     audit_text       TEXT
  ) ENGINE=InnoDB;

  CREATE TABLE cacertificates
  (
    cacertificates mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT cacertificates_id PRIMARY KEY (id)
  ) ENGINE=InnoDB;

  CREATE TABLE federations
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    type VARCHAR(24) NOT NULL,
    partner_id_hash VARCHAR(100) NOT NULL,
    federation_name_hash VARCHAR(100) NOT NULL,
    originator integer DEFAULT 1 NOT NULL,
    CONSTRAINT userfeds_pkey PRIMARY KEY (type, partner_id_hash, federation_name_hash),
    CONSTRAINT fed_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;

  CREATE INDEX fed_user_id_index ON federations (group_id, user_id);
  
  CREATE TABLE digitalids
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    dn_hash VARCHAR(100) NOT NULL,
    dn VARCHAR(255) DEFAULT NULL,
    managed_ca integer NOT NULL,
    digitalid_config integer NOT NULL,
    createrecover_date DATETIME NOT NULL,
    expiry_date DATETIME,
    CONSTRAINT digitalids_pkey PRIMARY KEY (dn_hash),
    CONSTRAINT digitalid_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;
  CREATE INDEX di_user_id_index ON digitalids (group_id, user_id);

  CREATE TABLE digitalid_clienttypes
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    dn_hash VARCHAR(100) NOT NULL,
    client_type VARCHAR(100) NOT NULL,
    createrecover_date DATETIME NOT NULL,
    CONSTRAINT digitalid_clienttypes_pkey PRIMARY KEY (dn_hash, client_type),
    CONSTRAINT digitalid_clienttypes_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;
  CREATE INDEX di_ct_user_id_index ON digitalid_clienttypes (group_id, user_id);

  CREATE TABLE smartcredentials
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    definition_id integer NOT NULL,
    serialnumber VARCHAR(255),
    sealed INTEGER NOT NULL,
    approved INTEGER NOT NULL,
    valid INTEGER NOT NULL,
    id VARCHAR(40) NOT NULL,
    state VARCHAR(40) NOT NULL,
    create_date DATETIME NOT NULL,
    expiry_date DATETIME,
    issue_state VARCHAR(40),
    issue_date DATETIME,
    supports_unblock integer NOT NULL,
    carduid VARCHAR(20),
    cardtype VARCHAR(20),
    mobilelicense SMALLINT DEFAULT NULL,
    idassuredlicense SMALLINT DEFAULT NULL,
    registered SMALLINT DEFAULT NULL,
    serverside SMALLINT DEFAULT NULL,
    CONSTRAINT smartcredentials_pkey PRIMARY KEY (id),
    CONSTRAINT User_smartcred_key FOREIGN KEY (group_id, user_id) 
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;
  CREATE INDEX sc_user_id_index ON smartcredentials (group_id, user_id);
  CREATE INDEX sc_sernum_index ON smartcredentials (serialnumber);
  CREATE INDEX sc_carduid_index ON smartcredentials (carduid);

  CREATE TABLE smartcredentialvariables
  (
    group_id integer,
    user_id VARCHAR(255),
    id VARCHAR(40) NOT NULL,
    name VARCHAR(255) NOT NULL,
    exactvalue VARCHAR(100),
    stringvalue VARCHAR(255),
    intvalue integer,
    datevalue DATETIME,
    CONSTRAINT smartcredvariables_pkey PRIMARY KEY (id,name),
    CONSTRAINT smartcredvar_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  ) ENGINE=InnoDB;
  CREATE INDEX scv_user_id_index ON smartcredentialvariables (group_id, user_id);

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

  CREATE TABLE managed_cas
  (
    managed_cas mediumblob,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT cas_pkey PRIMARY KEY (id)
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
