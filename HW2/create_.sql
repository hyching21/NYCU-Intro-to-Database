create table continent(
	Continent_Name varchar(100),
	Continent_Code char(2),
	primary key (Continent_Code)
);
create table country(
	Country_Name varchar(100) not NULL,
	Two_Letter_Country_Code char(2),
	Three_Letter_Country_Code char(3),
	Country_Number int,
	primary key(Three_Letter_Country_Code)
);
create table is_in(
	Continent_Code char(2),
	Three_Letter_Country_Code char(3),
	primary key(Continent_Code,Three_Letter_Country_Code),
	foreign key(Continent_Code)references continent,
	foreign key(Three_Letter_Country_Code)references country
);
create table policies(
	CountryCode varchar(3) not null,
	Date numeric(8,0) not null, 
	C1M int,C1M_flag bool,C2M int,C2M_flag bool,
	C3M int,C3M_flag bool,C4M int,C4M_flag bool,
	C5M int,C5M_flag bool,C6M int,C6M_flag bool,
	C7M int,C7M_flag bool,C8EV int,
	E1 int,E1_flag bool,E2 int,E3 double precision,E4 numeric,
	H1 int,H1_flag bool,
	H2 int,H3 int,H4 double precision,H5 double precision,
	H6 int,H6_flag bool,H7 int,H7_flag bool,H8 int,H8_flag bool,
	V1 int,V2A int,V2B varchar(20),V2C varchar(20),
	V2D int,V2E int,V2F int,V2G int,V3 int,V4 int,
	primary key(CountryCode,Date),
	foreign key(CountryCode)references country(Three_Letter_Country_Code)
);
create table vaccinated(
	PopulationVaccinated double precision,
	MajorityVaccinated varchar(2),
	primary key(PopulationVaccinated)
);
create table cases(
	CountryCode varchar(3) not null,
	Date numeric(8,0) not null, 
	ConfirmedCases int,
	ConfirmedDeaths int,
	PopulationVaccinated double precision,
	primary key(CountryCode,Date),
	foreign key(CountryCode)references country(Three_Letter_Country_Code),
	foreign key(PopulationVaccinated)references vaccinated(PopulationVaccinated)
);
create table indices(
	Country_Name varchar(100),
	CountryCode varchar(3) not null,
	Date numeric(8,0) not null,
	StringencyIndex_Average double precision,
	StringencyIndex_Average_ForDisplay double precision,
	GovernmentResponseIndex_Average double precision,
	GovernmentResponseIndex_Average_ForDisplay double precision,
	ContainmentHealthIndex_Average double precision,
	ContainmentHealthIndex_Average_ForDisplay double precision,
	EconomicSupportIndex double precision,
	EconomicSupportIndex_ForDisplay double precision,
	primary key(CountryCode,Date),
	foreign key(CountryCode)references country(Three_Letter_Country_Code)
);