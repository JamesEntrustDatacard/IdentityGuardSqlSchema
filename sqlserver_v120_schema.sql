--
-- Copyright 2004-2017 Entrust. All rights reserved.
--
-- This file defines the database schema used by Entrust IdentityGuard 12.0

-- Add the following statement to place the Entrust IdentityGuard tables in
-- your sql server database. Substitute your database name for <DBNAME>.
--
-- USE <DBNAME>; 
--
-- e.g., 
-- USE igdb;
--
 
  CREATE TABLE users
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    user_number integer NOT NULL,
    lockout_count integer NOT NULL,
    lockout_expiry DATETIME NOT NULL,
    user_info image NOT NULL,
    temporary_pin image,
    cards image,
    tokens image,
    certificates image DEFAULT NULL,
    auth_secrets image,
    federations image DEFAULT NULL,
    digitalids image DEFAULT NULL,
    smartcredentials image DEFAULT NULL,
    smartcredentialblobs image DEFAULT NULL,
    biometrics image DEFAULT NULL,
    user_state NVARCHAR(255) NOT NULL,
    activation_expiry DATETIME,
    pvn_state integer DEFAULT 0 NOT NULL,
    password_state NVARCHAR(255) DEFAULT NULL,
    password_expdate DATETIME DEFAULT NULL,
    num_qa integer DEFAULT 0 NOT NULL,
    num_reg_machines integer DEFAULT 0 NOT NULL,
    num_temp_pin_uses integer DEFAULT 0 NOT NULL,
    temppin_expdate DATETIME DEFAULT NULL,
    otp_allowed integer DEFAULT 1 NOT NULL,
    otp_delivery NVARCHAR(255) NOT NULL,
    num_cinfo integer DEFAULT 0 NOT NULL,
    num_usable_cinfo integer DEFAULT 0 NOT NULL,
    pvn_lastchangedate DATETIME DEFAULT NULL,
    num_locations integer DEFAULT 0 NOT NULL,
    num_otps integer DEFAULT NULL,
    otp_expdate DATETIME DEFAULT NULL,
    psswd_lastchngdate DATETIME DEFAULT NULL,
    fullname NVARCHAR(255),
    partition_id integer DEFAULT NULL,
    lastauthdate DATETIME DEFAULT NULL,
    lastauthtype VARCHAR(20) DEFAULT NULL,
    lastfailedauthdate DATETIME DEFAULT NULL,
    lastfailedauthtype VARCHAR(20) DEFAULT NULL,
    locale VARCHAR(20) DEFAULT NULL,
    sync_orphaned integer DEFAULT 0 NOT NULL,
    sync_unique_id NVARCHAR(255) DEFAULT NULL,
    pvn_expiredate DATETIME DEFAULT NULL,
    CONSTRAINT user_id_key PRIMARY KEY (group_id, user_id)
  );

  CREATE UNIQUE INDEX users_user_number_index ON users (user_number);
  CREATE INDEX users_username_index ON users (user_id);
  CREATE INDEX users_syncuid_index ON users (sync_unique_id);

  CREATE TABLE cards
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    serial_number NVARCHAR(255) NOT NULL,
    card_state NVARCHAR(255) NOT NULL,
    generate_date DATETIME NOT NULL,
    expiry_date DATETIME NOT NULL,
    challenge_count integer,
    least_used_cell_usage_count integer,
    card_usage_threshold_indicator NVARCHAR(255),
    CONSTRAINT cards_pkey PRIMARY KEY (serial_number),
    CONSTRAINT User_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );

  CREATE INDEX card_user_id_index ON cards (group_id, user_id);
  
  CREATE TABLE tokens
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    vendorid NVARCHAR(100) NOT NULL,
    serial_number NVARCHAR(255) NOT NULL,
    token_state NVARCHAR(255) NOT NULL,
    load_date DATETIME NOT NULL,
    lastused_date DATETIME NOT NULL,
    mobilelicense SMALLINT DEFAULT NULL,
    tvslicense SMALLINT DEFAULT NULL,
    teelicense SMALLINT DEFAULT NULL,
    CONSTRAINT usertokens_pkey PRIMARY KEY (vendorid, serial_number),
    CONSTRAINT token_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );

  CREATE INDEX token_user_id_index ON tokens (group_id, user_id);
  
  CREATE TABLE certificates
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    issuerdn_hash VARCHAR(100) NOT NULL,
    issuerdn NVARCHAR(512) NOT NULL,
    subjectdn NVARCHAR(512) NOT NULL,
    serial_number VARCHAR(50) NOT NULL,
    certificate_state NVARCHAR(20) NOT NULL,
    ca INTEGER NOT NULL,
    issue_date DATETIME NOT NULL,
    expiry_date DATETIME NOT NULL,
    assign_date DATETIME NOT NULL,
    lastused_date DATETIME NOT NULL,
    CONSTRAINT usercerts_pkey PRIMARY KEY (issuerdn_hash, serial_number),
    CONSTRAINT cert_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );

  CREATE INDEX cert_user_id_index ON certificates (group_id, user_id);
  
  CREATE TABLE aliases
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    alias   NVARCHAR(255) NOT NULL,
    CONSTRAINT alias_pkey PRIMARY KEY (group_id, alias),
    CONSTRAINT aliases_User_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );

  CREATE INDEX alias_user_id_index ON aliases (group_id, user_id);
  CREATE INDEX alias_username_index ON aliases (user_id);
  
  CREATE TABLE challenges
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    challenge image,
    CONSTRAINT challenges_pkey PRIMARY KEY (group_id, user_id),
    CONSTRAINT challenges_User_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );
  
  CREATE TABLE user_roles
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    role_id INTEGER NOT NULL,
    CONSTRAINT user_role_pkey PRIMARY KEY (group_id, user_id, role_id),
    CONSTRAINT user_role_user_fkey FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );

  CREATE TABLE globalpolicy
  (
    policy image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT globalpolicy_pkey PRIMARY KEY (id)
  );

  CREATE TABLE entpartitions
  (
    entpartition image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT partition_id PRIMARY KEY (id)
  );

  CREATE TABLE policy
  (
    policy image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT policy_id PRIMARY KEY (id)
  );

  CREATE TABLE policy_cardspec
  (
    cardspec image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT cardspec_id PRIMARY KEY (id)
  );

  CREATE TABLE policy_passwordpolicy
  (
    passwordpolicy image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT passwordpolicy_key PRIMARY KEY (id)
  );

  CREATE TABLE policy_temppinspec
  (
    temppinspec image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT temppinspec_id PRIMARY KEY (id)
  );

  CREATE TABLE policy_userspec
  (
    userspec image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT userspec_id PRIMARY KEY (id)
  );

  CREATE TABLE ipblacklist
  (
    ipblacklist image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT ipblacklist_id PRIMARY KEY (id)
  );

  CREATE TABLE roles
  (
    role_data image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT roles_pkey PRIMARY KEY (id)
  );

  CREATE TABLE groups
  (
    group_data image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT groups_pkey PRIMARY KEY (id)
  );

  CREATE TABLE smartcredential_printmodules
  (
    smartcredential_printmodules image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT printmodules_pkey PRIMARY KEY (id)
  );

  CREATE TABLE smartcredential_definitions
  (
    smartcredential_definitions image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT definition_pkey PRIMARY KEY (id)
  );

  CREATE TABLE smartcredential_applets
  (
    smartcredential_applets image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT applet_pkey PRIMARY KEY (id)
  );

  CREATE TABLE smartcredential_graphics
  (
    smartcredential_graphics image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT graphic_pkey PRIMARY KEY (id)
  );

  CREATE TABLE smartcredential_layouts
  (
    smartcredential_layouts image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT layout_pkey PRIMARY KEY (id)
  );

  CREATE TABLE digitalid_configs
  (
    digitalid_configs image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT digitialid_config_pkey PRIMARY KEY (id)
  );

  CREATE TABLE pacs
  (
    pacs image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT pacs_pkey PRIMARY KEY (id)
  );

  CREATE TABLE proxys
  (
    proxys image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT proxy_pkey PRIMARY KEY (id)
  );

  CREATE TABLE preproduced_cards
  (
     card_data image,
     create_date DATETIME NOT NULL,
     sernum DECIMAL(12, 0) NOT NULL,
     group_id integer DEFAULT 0 NOT NULL,
     CONSTRAINT preprod_pkey PRIMARY KEY (sernum)
  );

  CREATE TABLE unassigned_tokens
  (
     token_data image,
     load_date DATETIME NOT NULL,
     vendorid NVARCHAR(100) NOT NULL,
     sernum NVARCHAR(255) NOT NULL,
     group_id integer NOT NULL,
     CONSTRAINT token_pkey PRIMARY KEY (vendorid, sernum)
  );

  CREATE TABLE unassigned_smartcredentials
  (
     smartcredential_data image,
     load_date DATETIME NOT NULL,
     sernum NVARCHAR(255) NOT NULL,
     state NVARCHAR(40) NOT NULL,
     group_id integer NOT NULL,
     carduid VARCHAR(20),
     CONSTRAINT unassigned_sc_pkey PRIMARY KEY (sernum)
  );
  CREATE INDEX usc_carduid_index ON unassigned_smartcredentials (carduid);

  CREATE TABLE transcerts
  (
    transcerts image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT transcerts_id PRIMARY KEY (id)
  );

  CREATE TABLE audits
  (
     audit_seqno      BIGINT IDENTITY PRIMARY KEY,
     audit_date       DATETIME,
     audit_host       NVARCHAR(255),
     audit_level      NVARCHAR(10),
     audit_code       INTEGER,
     admin_group      NVARCHAR(255),
     admin_name       NVARCHAR(255),
     target_type      NVARCHAR(20),
     target_op        NVARCHAR(20),
     target_group     NVARCHAR(255),
     target_name      NVARCHAR(255),
     target_subname   NVARCHAR(255),
     audit_service    NVARCHAR(20),
     external_code    NVARCHAR(20),
     external_service NVARCHAR(255),
     audit_text       NTEXT
  );

  CREATE TABLE cacertificates
  (
    cacertificates image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT cacertificates_id PRIMARY KEY (id)
  );

  CREATE TABLE federations
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    type NVARCHAR(24) NOT NULL,
    partner_id_hash VARCHAR(100) NOT NULL,
    federation_name_hash VARCHAR(100) NOT NULL,
    originator integer DEFAULT 1 NOT NULL,
    CONSTRAINT userfeds_pkey PRIMARY KEY (type, partner_id_hash, federation_name_hash),
    CONSTRAINT fed_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );

  CREATE INDEX fed_user_id_index ON federations (group_id, user_id);

  CREATE TABLE digitalids
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    dn_hash VARCHAR(100) NOT NULL,
    dn NVARCHAR(255) DEFAULT NULL,
    managed_ca integer NOT NULL,
    digitalid_config integer NOT NULL,
    createrecover_date DATETIME NOT NULL,
    expiry_date DATETIME,
    CONSTRAINT digitalids_pkey PRIMARY KEY (dn_hash),
    CONSTRAINT digitalid_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );
  CREATE INDEX di_user_id_index ON digitalids (group_id, user_id);

  CREATE TABLE digitalid_clienttypes
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    dn_hash VARCHAR(100) NOT NULL,
    client_type NVARCHAR(100) NOT NULL,
    createrecover_date DATETIME NOT NULL,
    CONSTRAINT digitalid_clienttypes_pkey PRIMARY KEY (dn_hash, client_type),
    CONSTRAINT digitalid_clienttypes__user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );
  CREATE INDEX di_ct_user_id_index ON digitalid_clienttypes (group_id, user_id);

  CREATE TABLE smartcredentials
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    definition_id integer NOT NULL,
    id NVARCHAR(40) NOT NULL,
    state NVARCHAR(40) NOT NULL,
    serialnumber NVARCHAR(255),
    sealed integer NOT NULL,
    approved integer NOT NULL,
    valid integer NOT NULL,
    create_date DATETIME NOT NULL,
    expiry_date DATETIME,
    issue_state NVARCHAR(40),
    issue_date DATETIME,
    supports_unblock integer NOT NULL,
    carduid VARCHAR(20),
    cardtype VARCHAR(20),
    mobilelicense SMALLINT DEFAULT NULL,
    idassuredlicense SMALLINT DEFAULT NULL,
    registered SMALLINT DEFAULT NULL,
    serverside SMALLINT DEFAULT NULL,
    CONSTRAINT smartcredentials_pkey PRIMARY KEY (id),
    CONSTRAINT smartcred_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );
  CREATE INDEX sc_user_id_index ON smartcredentials (group_id, user_id);
  CREATE INDEX sc_sernum_index ON smartcredentials (serialnumber);
  CREATE INDEX sc_carduid_index ON smartcredentials (carduid);

  CREATE TABLE smartcredentialvariables
  (
    group_id integer,
    user_id NVARCHAR(255),
    id NVARCHAR(40) NOT NULL,
    name NVARCHAR(255) NOT NULL,
    exactvalue VARCHAR(100),
    stringvalue NVARCHAR(255),
    intvalue integer,
    datevalue DATETIME,
    CONSTRAINT smartcredvariables_pkey PRIMARY KEY (id,name),
    CONSTRAINT smartcredvar_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );
  CREATE INDEX scv_user_id_index ON smartcredentialvariables (group_id, user_id);

  CREATE TABLE biometrics
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    vendorid NVARCHAR(100) NOT NULL,
    state NVARCHAR(20) NOT NULL,
    enroll_state NVARCHAR(20) NOT NULL,
    enroll_date DATETIME NOT NULL,
    lastused_date DATETIME NOT NULL,
    CONSTRAINT userbiometrics_pkey PRIMARY KEY (group_id, user_id, vendorid),
    CONSTRAINT biometric_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );

  CREATE TABLE managed_cas
  (
    managed_cas image,
    id INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT cas_pkey PRIMARY KEY (id)
  );

  CREATE TABLE anonymous_challenges
  (
    anon_challenge_data image,
    create_date DATETIME NOT NULL,
    sernum DECIMAL(12, 0) NOT NULL,
    group_id integer DEFAULT 0 NOT NULL,
    transaction_id VARCHAR(255),
    CONSTRAINT anon_challenge_pkey PRIMARY KEY (sernum)
  );
