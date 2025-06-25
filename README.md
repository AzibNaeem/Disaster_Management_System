# 🌪️ ReliefFlow: A Disaster Management System

Welcome to **ReliefFlow**, a comprehensive, SQL-powered, Power BI-integrated solution to manage and visualize disaster relief operations. From hurricanes to pandemics, this system empowers organizations to respond efficiently using structured data and intelligent dashboards.

![ReliefFlow Banner](https://img.shields.io/badge/Status-Operational-green?style=flat-square) ![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square) ![PowerBI](https://img.shields.io/badge/PowerBI-Integrated-yellow.svg?style=flat-square)

---

## 📖 Table of Contents

- [🚀 Project Overview](#-project-overview)
- [🗃️ Database Schema](#-database-schema)
- [🧑‍💼 Participants and Teams](#-participants-and-teams)
- [📦 Resources and Allocation](#-resources-and-allocation)
- [📊 Power BI Dashboards](#-power-bi-dashboards)
- [⚙️ Setup & Usage](#️-setup--usage)
- [💡 Recommendations](#-recommendations)
- [📎 File Structure](#-file-structure)
- [👥 Author](#-author)

---

## 🚀 Project Overview

**ReliefFlow** is designed to streamline **global disaster response operations** by centralizing data management and facilitating coordination between volunteers, teams, and organizations. 

💡 Built with:
- **SQL Server** (Relational Schema + Triggers)
- **Power BI** (Dashboard & Reports)
- **Visual Analytics** for real-time decision-making

🔍 Main Features:
- Real-time tracking of disasters, volunteers, and resources
- Multi-layered team coordination
- Skill-based volunteer matching
- Visual dashboards for logistics, people, and operations

---

## 🗃️ Database Schema

The database design uses **relational modeling** with clear entity relationships and automation via **triggers**. Here's a snapshot:

📌 **Core Tables**:
- `DisasterEvent` 🌪️: Details of disasters (type, severity, dates)
- `Location` 📍: Affected geographic areas (city, state, country, coordinates)
- `ReliefOrganization` 🏢: NGOs and relief groups
- `Participant` 👤: Individuals (volunteers, leads, etc.)
- `ResponseTeam` 🛡️: Grouped response units
- `Resource` 📦: Inventory (food, water, shelter)
- `SkillType`, `VolunteerSkills` 🧠: Expertise and proficiency

📌 **Operational Tables**:
- `ResourceAllocation` 🚚
- `DisasterVolunteerAssignment` 🤝
- `DisasterResponseTeamAssignment` 🧭
- `TeamCoordination`, `VolunteerTeamCoordination` 🔄
- `OrganizationTeamCoordination` 🧬
- `VolunteerOrganizationCoordination` 📞

🔁 **Triggers**:
- Auto-update volunteer availability
- Adjust inventory on resource deployment or rollback

📈 **Sample Disasters Included**:
- Hurricane Katrina
- San Francisco Earthquake
- Miami Flood
- Australian Bushfires
- COVID-19 Pandemic

---

## 🧑‍💼 Participants and Teams

👥 **Participants**:
- Volunteers, Leads, Coordinators, etc.
- Roles defined in `RoleType`
- Skills rated via `SkillLevelType`

🛡️ **Response Teams**:
- Assigned to organizations
- Led by contact leads
- Specialized by function (e.g., Medical, Rescue)

📣 **Communication**:
- All inter-team, org-team, and volunteer-org communications are logged via coordination tables for traceability.

---

## 📦 Resources and Allocation

- Every resource (e.g., bottled water, food kits) is linked with `ResourceType`
- Allocation recorded per disaster
- Quantity and availability dynamically adjusted via triggers

Examples:
- 1000+ water bottles for Miami Flood 🌊
- First Aid kits for San Francisco Earthquake 🩹
- Tents for Australian Bushfire victims 🏕️

---

## 📊 Power BI Dashboards

### 🎯 Page 1: Overview
- Disaster timeline 📅
- Geographic impact map 🌍
- Severity breakdown bar chart 📊

### 🛠️ Page 2: Resources & Logistics
- Resource inventory status
- Allocation progress donuts 🥯
- Pending vs. completed deployments

### 👥 Page 3: People & Coordination
- Active volunteers
- Skill distribution 📈
- Team assignment matrix

> 📂 PBIX File: `DisasterSystem Visuals.pbix`

---

## ⚙️ Setup & Usage

### 🛠 Prerequisites
- SQL Server 2019+
- Power BI Desktop
- Git

### 🔧 Steps

1. **Clone this repository**
   ```bash
   git clone https://github.com/yourusername/reliefflow.git
   cd reliefflow
   ```

2. **Create the Database**
   - Run `DisasterSytemSchema.sql` in your SQL Server environment to set up tables, triggers, and initial data.

3. **Open Power BI File**
   - Load `DisasterSystem Visuals.pbix` in Power BI Desktop
   - Connect to your local SQL Server if needed

4. **Explore the Dashboard**
   - Navigate through the 3 pages for insights

---

## 💡 Recommendations

🔮 Future Improvements:
- Integrate real-time feeds for dynamic disaster reporting
- Add predictive analytics for resource preallocation
- Expand volunteer training based on skill data
- Deploy mobile interface for on-ground teams 📱

---

## 📎 File Structure

```
📁 reliefflow/
├── 📄 README.md
├── 📄 DisasterSytemSchema.sql      # Full database schema & data
├── 📄 DisasterSystem Visuals.pbix  # Power BI dashboard
├── 📄 ReliefFlow.pdf               # Academic project report
```

---

## 👥 Author

**Azib Naeem**  
📧 Email: [azibnaeem17official@gmail.com](mailto:azibnaeem17official@gmail.com)  
📅 Project Date: May 2025

---

> ✅ *ReliefFlow combines structured data design and business intelligence into a powerful disaster relief coordination platform.*  
> 🌱 *Scalable, interactive, and built for impact.*
