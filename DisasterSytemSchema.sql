USE master
DROP DATABASE Project_1
GO
CREATE DATABASE Project_1
GO

USE Project_1
GO

-- Drop existing tables if any
DROP TABLE IF EXISTS DisasterResponseTeamAssignment;
DROP TABLE IF EXISTS DisasterVolunteerAssignment;
DROP TABLE IF EXISTS DisasterAffectedRegion;
DROP TABLE IF EXISTS ResourceAllocation;
DROP TABLE IF EXISTS VolunteerOrganizationCoordination;
DROP TABLE IF EXISTS OrganizationTeamCoordination;
DROP TABLE IF EXISTS VolunteerTeamCoordination;
DROP TABLE IF EXISTS TeamCoordination;
DROP TABLE IF EXISTS TeamMember;
DROP TABLE IF EXISTS ResponseTeam;
DROP TABLE IF EXISTS Participant;
DROP TABLE IF EXISTS ReliefOrganization;
DROP TABLE IF EXISTS [Resource];
DROP TABLE IF EXISTS [Location];
DROP TABLE IF EXISTS DisasterEvent;
DROP TABLE IF EXISTS OrganizationRegion;
DROP TABLE IF EXISTS SkillType;
DROP TABLE IF EXISTS VolunteerSkills;
DROP TABLE IF EXISTS RoleType;
DROP TABLE IF EXISTS ResourceType;
DROP TABLE IF EXISTS SkillLevelType;
GO

-- Lookup Tables
CREATE TABLE RoleType (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE ResourceType (
    TypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE SkillLevelType (
    LevelID INT IDENTITY(1,1) PRIMARY KEY,
    LevelName VARCHAR(20) NOT NULL UNIQUE
);

-- Core Entities
CREATE TABLE DisasterEvent (
    DisasterID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(100) NOT NULL,
    Type VARCHAR(50) NOT NULL,
    Severity VARCHAR(20) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NULL,
    [Description] TEXT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT CK_DisasterEvent_Severity CHECK (Severity IN ('Low', 'Moderate', 'High', 'Critical'))
);

CREATE TABLE [Location] (
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    City VARCHAR(50) NOT NULL,
    [State] VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    Latitude DECIMAL(9,6) NOT NULL,
    Longitude DECIMAL(9,6) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT uk_Location UNIQUE (City, State, Country)
);

CREATE TABLE ReliefOrganization (
    OrgID INT IDENTITY(1,1) PRIMARY KEY,
    OrgName VARCHAR(100) NOT NULL,
    ContactEmail VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NULL,
    RegionCovered VARCHAR(100) NULL,
    ActiveStatus BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT uk_OrgEmail UNIQUE (ContactEmail)
);

CREATE TABLE OrganizationRegion (
    RegionID INT IDENTITY(1,1) PRIMARY KEY,
    OrgID INT NOT NULL,
    RegionName VARCHAR(100) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (OrgID) REFERENCES ReliefOrganization(OrgID) ON DELETE CASCADE
);

CREATE TABLE Participant (
    ParticipantID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Age INT NULL,
    RoleID INT NOT NULL,
    Contact VARCHAR(50) NULL,
    AvailabilityStatus VARCHAR(20) DEFAULT 'Available',
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RoleID) REFERENCES RoleType(RoleID),
    CONSTRAINT CK_Participant_AvailabilityStatus CHECK (AvailabilityStatus IN ('Available', 'Assigned', 'Unavailable'))
);

CREATE TABLE SkillType (
    SkillID INT IDENTITY(1,1) PRIMARY KEY,
    SkillName VARCHAR(100) NOT NULL,
    Description TEXT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE VolunteerSkills (
    VolunteerID INT NOT NULL,
    SkillID INT NOT NULL,
    LevelID INT NOT NULL,
    PRIMARY KEY (VolunteerID, SkillID),
    FOREIGN KEY (VolunteerID) REFERENCES Participant(ParticipantID) ON DELETE CASCADE,
    FOREIGN KEY (SkillID) REFERENCES SkillType(SkillID) ON DELETE CASCADE,
    FOREIGN KEY (LevelID) REFERENCES SkillLevelType(LevelID)
);

CREATE TABLE ResponseTeam (
    TeamID INT IDENTITY(1,1) PRIMARY KEY,
    TeamName VARCHAR(100) NOT NULL,
    OrgID INT NOT NULL,
    ContactLeadID INT NULL,
    Specialization VARCHAR(100) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (OrgID) REFERENCES ReliefOrganization(OrgID),
    FOREIGN KEY (ContactLeadID) REFERENCES Participant(ParticipantID)
);

CREATE TABLE TeamMember (
    TeamID INT NOT NULL,
    ParticipantID INT NOT NULL,
    JoinDate DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (TeamID, ParticipantID),
    FOREIGN KEY (TeamID) REFERENCES ResponseTeam(TeamID) ON DELETE CASCADE,
    FOREIGN KEY (ParticipantID) REFERENCES Participant(ParticipantID) ON DELETE CASCADE
);

CREATE TABLE [Resource] (
    ResourceID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    TypeID INT NOT NULL,
    Description TEXT NULL,
    Unit VARCHAR(20) NOT NULL,
    QuantityAvailable INT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TypeID) REFERENCES ResourceType(TypeID)
);

-- Coordination Tables
CREATE TABLE TeamCoordination (
    CoordinationID INT IDENTITY(1,1) PRIMARY KEY,
    SenderTeamID INT NOT NULL,
    ReceiverTeamID INT NOT NULL,
    Message TEXT NOT NULL,
    Medium VARCHAR(50) NOT NULL,
    Timestamp DATETIME DEFAULT GETDATE(),
    ReadStatus BIT DEFAULT 0,
    FOREIGN KEY (SenderTeamID) REFERENCES ResponseTeam(TeamID) ON DELETE CASCADE,
    FOREIGN KEY (ReceiverTeamID) REFERENCES ResponseTeam(TeamID) ON DELETE NO ACTION
);

CREATE TABLE VolunteerTeamCoordination (
    CoordinationID INT IDENTITY(1,1) PRIMARY KEY,
    VolunteerID INT NOT NULL,
    TeamID INT NOT NULL,
    Direction VARCHAR(10) NOT NULL CHECK (Direction IN ('ToTeam', 'ToVolunteer')),
    Message TEXT NOT NULL,
    Medium VARCHAR(50) NOT NULL,
    Timestamp DATETIME DEFAULT GETDATE(),
    ReadStatus BIT DEFAULT 0,
    FOREIGN KEY (VolunteerID) REFERENCES Participant(ParticipantID) ON DELETE CASCADE,
    FOREIGN KEY (TeamID) REFERENCES ResponseTeam(TeamID) ON DELETE CASCADE
);

CREATE TABLE OrganizationTeamCoordination (
    CoordinationID INT IDENTITY(1,1) PRIMARY KEY,
    OrgID INT NOT NULL,
    TeamID INT NOT NULL,
    Direction VARCHAR(10) NOT NULL CHECK (Direction IN ('ToTeam', 'ToOrg')),
    Message TEXT NOT NULL,
    Medium VARCHAR(50) NOT NULL,
    Timestamp DATETIME DEFAULT GETDATE(),
    ReadStatus BIT DEFAULT 0,
    FOREIGN KEY (OrgID) REFERENCES ReliefOrganization(OrgID) ON DELETE CASCADE,
    FOREIGN KEY (TeamID) REFERENCES ResponseTeam(TeamID) ON DELETE CASCADE
);

CREATE TABLE VolunteerOrganizationCoordination (
    CoordinationID INT IDENTITY(1,1) PRIMARY KEY,
    VolunteerID INT NOT NULL,
    OrgID INT NOT NULL,
    Direction VARCHAR(10) NOT NULL CHECK (Direction IN ('ToOrg', 'ToVolunteer')),
    Message TEXT NOT NULL,
    Medium VARCHAR(50) NOT NULL,
    Timestamp DATETIME DEFAULT GETDATE(),
    ReadStatus BIT DEFAULT 0,
    FOREIGN KEY (VolunteerID) REFERENCES Participant(ParticipantID) ON DELETE CASCADE,
    FOREIGN KEY (OrgID) REFERENCES ReliefOrganization(OrgID) ON DELETE CASCADE
);

-- Junction Tables
CREATE TABLE ResourceAllocation (
    AllocationID INT IDENTITY(1,1) PRIMARY KEY,
    DisasterID INT NOT NULL,
    ResourceID INT NOT NULL,
    Quantity INT NOT NULL,
    AllocationDate DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Pending',
    Remarks TEXT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DisasterID) REFERENCES DisasterEvent(DisasterID),
    FOREIGN KEY (ResourceID) REFERENCES Resource(ResourceID),
    CONSTRAINT CK_RA_Status CHECK (Status IN ('Pending', 'Completed', 'Cancelled'))
);

CREATE TABLE DisasterAffectedRegion (
    AffectedRegionID INT IDENTITY(1,1) PRIMARY KEY,
    DisasterID INT NOT NULL,
    LocationID INT NOT NULL,
    ImpactDetails TEXT NULL,
    EffectiveDate DATETIME DEFAULT GETDATE(),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DisasterID) REFERENCES DisasterEvent(DisasterID),
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
);

CREATE TABLE DisasterVolunteerAssignment (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    DisasterID INT NOT NULL,
    VolunteerID INT NOT NULL,
    Role VARCHAR(50) NOT NULL,
    AssignmentDate DATETIME DEFAULT GETDATE(),
    EndDate DATETIME NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DisasterID) REFERENCES DisasterEvent(DisasterID),
    FOREIGN KEY (VolunteerID) REFERENCES Participant(ParticipantID)
);

CREATE TABLE DisasterResponseTeamAssignment (
    TeamAssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    DisasterID INT NOT NULL,
    TeamID INT NOT NULL,
    AssignmentDate DATETIME DEFAULT GETDATE(),
    DeploymentStatus VARCHAR(20) DEFAULT 'Deployed',
    Remarks TEXT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DisasterID) REFERENCES DisasterEvent(DisasterID),
    FOREIGN KEY (TeamID) REFERENCES ResponseTeam(TeamID),
    CONSTRAINT CK_DRTA_DeploymentStatus CHECK (DeploymentStatus IN ('Deployed', 'Completed', 'Cancelled'))
);
GO


CREATE TRIGGER TR_DisasterEvent_Update
ON DisasterEvent
AFTER UPDATE
AS
BEGIN
    UPDATE DisasterEvent
    SET UpdatedAt = GETDATE()
    FROM DisasterEvent d
    INNER JOIN inserted i ON d.DisasterID = i.DisasterID;
END;
GO


-- When a volunteer is assigned to a disaster
CREATE TRIGGER TR_DisasterVolunteerAssignment_Insert
ON DisasterVolunteerAssignment
AFTER INSERT
AS
BEGIN
    UPDATE Participant
    SET AvailabilityStatus = 'Assigned'
    FROM Participant p
    INNER JOIN inserted i ON p.ParticipantID = i.VolunteerID;
END;
GO

-- When an assignment ends (deleted)
CREATE TRIGGER TR_DisasterVolunteerAssignment_Delete
ON DisasterVolunteerAssignment
AFTER DELETE
AS
BEGIN
    UPDATE Participant
    SET AvailabilityStatus = 'Available'
    FROM Participant p
    INNER JOIN deleted d ON p.ParticipantID = d.VolunteerID;
END;
GO


-- When a resource is allocated
CREATE TRIGGER TR_ResourceAllocation_Insert
ON ResourceAllocation
AFTER INSERT
AS
BEGIN
    UPDATE Resource
    SET QuantityAvailable = QuantityAvailable - i.Quantity
    FROM Resource r
    INNER JOIN inserted i ON r.ResourceID = i.ResourceID
    WHERE i.Status = 'Pending';
END;
GO

-- When an allocation is cancelled or removed
CREATE TRIGGER TR_ResourceAllocation_Delete
ON ResourceAllocation
AFTER DELETE
AS
BEGIN
    UPDATE Resource
    SET QuantityAvailable = QuantityAvailable + d.Quantity
    FROM Resource r
    INNER JOIN deleted d ON r.ResourceID = d.ResourceID
    WHERE d.Status = 'Pending';
END;
GO

-- ===============================================================================================
-- Populate Lookup Tables
-- ===============================================================================================


-- RoleType: Defines roles for participants
INSERT INTO RoleType (RoleName) VALUES 
('Volunteer'), 
('Team Member'), 
('Contact Lead'), 
('Coordinator'), 
('Manager');

-- ResourceType: Defines types of resources
INSERT INTO ResourceType (TypeName) VALUES 
('Food'), 
('Water'), 
('Medical Supplies'), 
('Shelter'), 
('Transportation');

-- SkillLevelType: Defines skill proficiency levels
INSERT INTO SkillLevelType (LevelName) VALUES 
('Beginner'), 
('Intermediate'), 
('Expert');

-- SkillType: Defines skills relevant to disaster response
INSERT INTO SkillType (SkillName, Description) VALUES 
('First Aid', 'Basic medical assistance'),
('Search and Rescue', 'Locating and rescuing victims'),
('Logistics', 'Managing supplies and transportation'),
('Communication', 'Handling communication equipment'),
('Counseling', 'Providing emotional support');

-- ===============================================================================================
-- Populate Core Entity Tables
-- ===============================================================================================

-- Location: Locations that could be affected by disasters
INSERT INTO Location (City, State, Country, Latitude, Longitude) VALUES 
('New Orleans', 'Louisiana', 'USA', 29.9511, -90.0715),
('San Francisco', 'California', 'USA', 37.7749, -122.4194),
('Miami', 'Florida', 'USA', 25.7617, -80.1918),
('Sydney', 'New South Wales', 'Australia', -33.8688, 151.2093),
('Tokyo', 'Tokyo', 'Japan', 35.6895, 139.6917);

-- ReliefOrganization: Organizations managing disaster relief efforts
INSERT INTO ReliefOrganization (OrgName, ContactEmail, Phone, RegionCovered, ActiveStatus) VALUES 
('Global Relief Fund', 'contact@grf.org', '123-456-7890', 'Worldwide', 1),
('Disaster Aid International', 'info@dai.org', '987-654-3210', 'Asia-Pacific', 1),
('Local Volunteer Corps', 'volunteer@lvc.org', '555-123-4567', 'North America', 1);

-- Participant: Individuals involved in relief efforts
INSERT INTO Participant (Name, Age, RoleID, Contact, AvailabilityStatus) VALUES 
('John Doe', 30, 1, 'john@example.com', 'Available'),    -- Volunteer
('Jane Smith', 25, 1, 'jane@example.com', 'Available'),   -- Volunteer
('Alice Johnson', 35, 3, 'alice@example.com', 'Available'), -- Contact Lead
('Bob Brown', 40, 2, 'bob@example.com', 'Available'),     -- Team Member
('Charlie Davis', 28, 1, 'charlie@example.com', 'Available'), -- Volunteer
('David Evans', 45, 3, 'david@example.com', 'Available'); -- Contact Lead

-- ResponseTeam: Teams linked to organizations, with a contact lead
INSERT INTO ResponseTeam (TeamName, OrgID, ContactLeadID, Specialization) VALUES 
('Team Alpha', 1, 3, 'Medical Assistance'), -- Alice Johnson (ID 3)
('Team Beta', 2, 6, 'Search and Rescue');   -- David Evans (ID 6)

-- Resource: Resources available for allocation
INSERT INTO [Resource] (Name, TypeID, Description, Unit, QuantityAvailable) VALUES 
('Canned Food', 1, 'Non-perishable food items', 'cans', 1000),
('Bottled Water', 2, 'Drinking water', 'bottles', 5000),
('First Aid Kits', 3, 'Basic medical supplies', 'kits', 200),
('Tents', 4, 'Temporary shelter', 'units', 50),
('Trucks', 5, 'Transportation vehicles', 'vehicles', 10);

-- VolunteerSkills: Assigns skills to volunteers
INSERT INTO VolunteerSkills (VolunteerID, SkillID, LevelID) VALUES 
(1, 1, 2), -- John Doe: First Aid (Intermediate)
(1, 2, 1), -- John Doe: Search and Rescue (Beginner)
(2, 3, 3), -- Jane Smith: Logistics (Expert)
(2, 4, 2), -- Jane Smith: Communication (Intermediate)
(5, 5, 1); -- Charlie Davis: Counseling (Beginner)

-- TeamMember: Assigns participants to response teams
INSERT INTO TeamMember (TeamID, ParticipantID) VALUES 
(1, 2), -- Team Alpha: Jane Smith
(1, 4), -- Team Alpha: Bob Brown
(2, 5); -- Team Beta: Charlie Davis

-- OrganizationRegion: Links organizations to regions they cover
INSERT INTO OrganizationRegion (OrgID, RegionName) VALUES 
(1, 'Worldwide'),
(2, 'Asia-Pacific'),
(3, 'North America');

-- ===============================================================================================
-- Disaster 1: Hurricane Katrina
-- ===============================================================================================

INSERT INTO DisasterEvent (Name, Type, Severity, StartDate, EndDate, Description) VALUES 
('Hurricane Katrina', 'Hurricane', 'Critical', '2005-08-23', '2005-08-31', 'Devastating hurricane that hit the Gulf Coast');

-- DisasterAffectedRegion: Link to New Orleans (LocationID=1)
INSERT INTO DisasterAffectedRegion (DisasterID, LocationID, ImpactDetails) VALUES 
(1, 1, 'Extensive flooding and damage to infrastructure');

-- DisasterVolunteerAssignment: Assign John Doe as a First Aid Provider
INSERT INTO DisasterVolunteerAssignment (DisasterID, VolunteerID, Role, AssignmentDate) VALUES 
(1, 1, 'First Aid Provider', '2005-08-25');

-- DisasterResponseTeamAssignment: Deploy Team Alpha for medical assistance
INSERT INTO DisasterResponseTeamAssignment (DisasterID, TeamID, AssignmentDate, DeploymentStatus) VALUES 
(1, 1, '2005-08-24', 'Deployed');

-- ResourceAllocation: Allocate canned food for survivors
INSERT INTO ResourceAllocation (DisasterID, ResourceID, Quantity, AllocationDate, Status) VALUES 
(1, 1, 500, '2005-08-26', 'Completed');

-- TeamCoordination: Coordinate between teams for additional supplies
INSERT INTO TeamCoordination (SenderTeamID, ReceiverTeamID, Message, Medium, Timestamp, ReadStatus) VALUES 
(1, 2, 'Need additional medical supplies for Katrina relief', 'Email', '2005-08-27 10:00:00', 0);

-- ===============================================================================================
-- Disaster 2: San Francisco Earthquake
-- ===============================================================================================

INSERT INTO DisasterEvent (Name, Type, Severity, StartDate, EndDate, Description) VALUES 
('San Francisco Earthquake', 'Earthquake', 'High', '1989-10-17', '1989-10-17', 'Major earthquake in the Bay Area');

-- DisasterAffectedRegion: Link to San Francisco (LocationID=2)
INSERT INTO DisasterAffectedRegion (DisasterID, LocationID, ImpactDetails) VALUES 
(2, 2, 'Collapsed buildings and infrastructure');

-- DisasterVolunteerAssignment: Assign Bob Brown for search and rescue
INSERT INTO DisasterVolunteerAssignment (DisasterID, VolunteerID, Role, AssignmentDate) VALUES 
(2, 4, 'Search and Rescue', '1989-10-18');

-- DisasterResponseTeamAssignment: Deploy Team Beta for search and rescue
INSERT INTO DisasterResponseTeamAssignment (DisasterID, TeamID, AssignmentDate, DeploymentStatus) VALUES 
(2, 2, '1989-10-17', 'Deployed');

-- ResourceAllocation: Allocate first aid kits for immediate response
INSERT INTO ResourceAllocation (DisasterID, ResourceID, Quantity, AllocationDate, Status) VALUES 
(2, 3, 50, '1989-10-18', 'Completed');

-- VolunteerTeamCoordination: Bob Brown reports to Team Beta
INSERT INTO VolunteerTeamCoordination (VolunteerID, TeamID, Direction, Message, Medium, Timestamp, ReadStatus) VALUES 
(4, 2, 'ToTeam', 'Found survivors in Sector 3', 'Radio', '1989-10-19 14:00:00', 0);

-- ===============================================================================================
-- Disaster 3: Miami Flood
-- ===============================================================================================

INSERT INTO DisasterEvent (Name, Type, Severity, StartDate, EndDate, Description) VALUES 
('Miami Flood', 'Flood', 'Moderate', '2020-06-05', '2020-06-10', 'Severe flooding due to heavy rains');

-- DisasterAffectedRegion: Link to Miami (LocationID=3)
INSERT INTO DisasterAffectedRegion (DisasterID, LocationID, ImpactDetails) VALUES 
(3, 3, 'Flooded streets and homes');

-- DisasterVolunteerAssignment: Assign Jane Smith as logistics coordinator
INSERT INTO DisasterVolunteerAssignment (DisasterID, VolunteerID, Role, AssignmentDate) VALUES 
(3, 2, 'Logistics Coordinator', '2020-06-06');

-- ResourceAllocation: Allocate bottled water for affected residents
INSERT INTO ResourceAllocation (DisasterID, ResourceID, Quantity, AllocationDate, Status) VALUES 
(3, 2, 1000, '2020-06-06', 'Pending');

-- OrganizationTeamCoordination: Global Relief Fund notifies Team Alpha
INSERT INTO OrganizationTeamCoordination (OrgID, TeamID, Direction, Message, Medium, Timestamp, ReadStatus) VALUES 
(1, 1, 'ToTeam', 'Additional resources en route for Miami Flood', 'Email', '2020-06-07 09:00:00', 0);

-- ===============================================================================================
-- Disaster 4: Australian Bushfires
-- ===============================================================================================

INSERT INTO DisasterEvent (Name, Type, Severity, StartDate, EndDate, Description) VALUES 
('Australian Bushfires', 'Wildfire', 'Critical', '2019-09-01', '2020-03-31', 'Widespread bushfires across Australia');

-- DisasterAffectedRegion: Link to Sydney (LocationID=4)
INSERT INTO DisasterAffectedRegion (DisasterID, LocationID, ImpactDetails) VALUES 
(4, 4, 'Burned forests and wildlife loss');

-- DisasterVolunteerAssignment: Assign Charlie Davis as a counselor
INSERT INTO DisasterVolunteerAssignment (DisasterID, VolunteerID, Role, AssignmentDate) VALUES 
(4, 5, 'Counselor', '2019-10-01');

-- DisasterResponseTeamAssignment: Deploy Team Beta for support
INSERT INTO DisasterResponseTeamAssignment (DisasterID, TeamID, AssignmentDate, DeploymentStatus) VALUES 
(4, 2, '2019-09-15', 'Deployed');

-- ResourceAllocation: Allocate tents for displaced persons
INSERT INTO ResourceAllocation (DisasterID, ResourceID, Quantity, AllocationDate, Status) VALUES 
(4, 4, 20, '2019-09-20', 'Completed');

-- VolunteerOrganizationCoordination: Charlie Davis requests more support
INSERT INTO VolunteerOrganizationCoordination (VolunteerID, OrgID, Direction, Message, Medium, Timestamp, ReadStatus) VALUES 
(5, 2, 'ToOrg', 'Requesting more counseling support for bushfire victims', 'Phone', '2019-10-05 11:00:00', 0);

-- ===============================================================================================
-- Disaster 5: COVID-19 Pandemic
-- ===============================================================================================

INSERT INTO DisasterEvent (Name, Type, Severity, StartDate, EndDate, Description) VALUES 
('COVID-19 Pandemic', 'Pandemic', 'Critical', '2020-01-01', NULL, 'Global pandemic caused by SARS-CoV-2');

-- DisasterAffectedRegion: Link to Tokyo (LocationID=5)
INSERT INTO DisasterAffectedRegion (DisasterID, LocationID, ImpactDetails) VALUES 
(5, 5, 'High infection rates and lockdowns');

-- DisasterVolunteerAssignment: Assign Alice Johnson as contact lead
INSERT INTO DisasterVolunteerAssignment (DisasterID, VolunteerID, Role, AssignmentDate) VALUES 
(5, 3, 'Contact Lead', '2020-03-15');

-- ResourceAllocation: Allocate first aid kits for medical support
INSERT INTO ResourceAllocation (DisasterID, ResourceID, Quantity, AllocationDate, Status) VALUES 
(5, 3, 100, '2020-03-20', 'Completed');

-- TeamCoordination: Coordinate vaccine distribution efforts
INSERT INTO TeamCoordination (SenderTeamID, ReceiverTeamID, Message, Medium, Timestamp, ReadStatus) VALUES 
(1, 2, 'Coordinating vaccine distribution for COVID-19', 'Email', '2021-01-01 10:00:00', 0);

SELECT * FROM DisasterEvent;
SELECT * FROM [Location];
SELECT * FROM ReliefOrganization;
SELECT * FROM Participant;
SELECT * FROM ResponseTeam;
SELECT * FROM [Resource];
SELECT * FROM SkillType;
SELECT * FROM VolunteerSkills;
SELECT * FROM TeamMember;
SELECT * FROM DisasterAffectedRegion;
SELECT * FROM DisasterVolunteerAssignment;
SELECT * FROM DisasterResponseTeamAssignment;
SELECT * FROM ResourceAllocation;
SELECT * FROM TeamCoordination;
SELECT * FROM VolunteerTeamCoordination;
SELECT * FROM OrganizationTeamCoordination;
SELECT * FROM VolunteerOrganizationCoordination;

SELECT name 
FROM sys.tables 
ORDER BY name

