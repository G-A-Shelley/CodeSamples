
CREATE TABLE 'zones' (
	'name'			TEXT NOT NULL PRIMARY KEY,
	'continent'		TEXT,
	'region'		TEXT,
	'type'			TEXT,
	'info'			TEXT
)

CREATE TABLE 'battlefields' (
	'name'			TEXT NOT NULL PRIMARY KEY,
	'zone'			TEXT,
	'category'		TEXT,
	'entry'			TEXT,
	CONSTRAINT fk_mob_zone
	    FOREIGN KEY (zone)
	    REFERENCES zones(name)
)

CREATE TABLE 'type' (
	'name'					TEXT NOT NULL PRIMARY KEY,
	'intimidate_by'	TEXT,
	'intimidate_to'	TEXT,
)

CREATE TABLE 'family' (
	'name'					TEXT NOT NULL PRIMARY KEY,
	'type'					TEXT,
	'crystal'				TEXT,
	'resist_mag'			TEXT,
	'resist_phy'			TEXT,
	'charm'					TEXT,
	CONSTRAINT fk_famil_type
	    FOREIGN KEY (name)
	    REFERENCES type(name)
)

CREATE TABLE `mob` (
	'name'				TEXT NOT NULL,
	`zone` 				TEXT NOT NULL,
	`family`			TEXT,
	`job`				TEXT,
	`level_min`			INTEGER,
	`level_max`			INTEGER,
	`nm`				INTEGER NOT NULL DEFAULT 0,
	'pos' 				TEXT,
	`spawns`			INT,
	'appearance' 		TEXT,
	'conditions' 		TEXT,
	`links`				INTEGER NOT NULL DEFAULT 0,
	`aggressive`		INTEGER NOT NULL DEFAULT 0,
	`sight`				INTEGER NOT NULL DEFAULT 0,
	`sound`				INTEGER NOT NULL DEFAULT 0,
	`magic`				INTEGER NOT NULL DEFAULT 0,
	`hp`				INTEGER NOT NULL DEFAULT 0,
	`healing`			INTEGER NOT NULL DEFAULT 0,
	'ability'			INTEGER NOT NULL DEFAULT 0,
	`truesight`			INTEGER NOT NULL DEFAULT 0,
	`truesound`			INTEGER NOT NULL DEFAULT 0,
	`scent`				INTEGER NOT NULL DEFAULT 0,
	`immune`			TEXT,
	'resist'			TEXT,
	`drops`				TEXT,
	'notes'				TEXT,
	PRIMARY KEY(name, zone)
	CONSTRAINT fk_mob_zone
	    FOREIGN KEY (zone)
	    REFERENCES zones(name)
	CONSTRAINT fk_mob_family
	    FOREIGN KEY (family)
	    REFERENCES family(name)

)

CREATE TABLE 'npc' (
	'name' 		TEXT NOT NULL,
	`zone`  	TEXT NOT NULL,
	'pos'		TEXT,
	'info'		TEXT,
	'notes'		TEXT,
	PRIMARY KEY(name, zone)
	CONSTRAINT fk_npc_zone
    FOREIGN KEY (zone)
    REFERENCES zones(name)
)

CREATE TABLE 'pc' (
	'name'		TEXT PRIMARY KEY,
	'notes'		TEXT
)