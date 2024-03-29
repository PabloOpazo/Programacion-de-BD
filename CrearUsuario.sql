ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- USER SQL
CREATE USER duoc IDENTIFIED BY duoc
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS
ALTER USER duoc QUOTA UNLIMITED ON USERS;

-- ROLES
GRANT "RESOURCE" TO duoc ;
GRANT "CONNECT" TO duoc ;
ALTER USER duoc DEFAULT ROLE "RESOURCE","CONNECT";
