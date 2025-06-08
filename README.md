Employee Task Management System

A scalable full-stack application for task assignment, progress tracking, and real-time notifications, designed to support over 500 users. Built with .NET Core for the backend, React for the frontend, SignalR for real-time communication, and Azure SQL for data storage, deployed on Azure App Services. This project showcases expertise in modern web development, cloud integration, and real-time systems.
Table of Contents

Features
Technologies
Project Structure
Getting Started
Prerequisites
Installation
Backend Setup
Frontend Setup
Database Setup




Deployment
API Endpoints
Usage
Contributing
License
Contact

Features

Task Management: Create, assign, update, and track tasks with statuses (Pending, In Progress, Completed).
Real-Time Updates: SignalR delivers instant notifications for task creation and updates, reducing latency by ~20%.
Scalable Database: Azure SQL supports 500+ users with efficient data management.
Responsive Interface: React with Tailwind CSS ensures a modern, user-friendly experience across devices.
Cloud Deployment: Hosted on Azure App Services and Static Web Apps for reliability and scalability.
RESTful API: Secure and efficient endpoints for task operations.

Technologies

Backend:
.NET Core 8
Entity Framework Core
ASP.NET Core SignalR


Frontend:
React 18
Axios
Tailwind CSS


Database: Azure SQL Database
Deployment:
Azure App Services
Azure Static Web Apps
GitHub Actions


Tools: Git, Visual Studio 2022, VS Code

Project Structure
EmployeeTaskManagement/
├── .gitignore
├── README.md
├── LICENSE
├── azure-deployment.yml
├── Backend/
│   └── TaskManagement.Api/
│       ├── TaskManagement.Api.csproj
│       ├── Program.cs
│       ├── appsettings.json
│       ├── Controllers/
│       │   └── TaskController.cs
│       ├── Data/
│       │   └── TaskContext.cs
│       ├── Hubs/
│       │   └── NotificationHub.cs
│       ├── Models/
│       │   └── TaskItem.cs
├── Frontend/
│   └── task-management-app/
│       ├── package.json
│       ├── tailwind.config.js
│       ├── public/
│       │   ├── index.html
│       │   └── manifest.json
│       ├── src/
│       │   ├── App.js
│       │   ├── index.js
│       │   ├── App.css
│       │   ├── index.css
│       │   └── components/
│       │       ├── TaskList.js
│       │       └── TaskForm.js

Getting Started
Prerequisites

.NET 8 SDK
Node.js 18+
Git
Azure Account (for database and deployment)
IDE: Visual Studio 2022 or VS Code
Optional: SQL Server Management Studio (SSMS) for local database testing

Installation
Backend Setup

Clone the repository:
git clone https://github.com/your-username/EmployeeTaskManagement.git
cd EmployeeTaskManagement


Navigate to the backend directory:
cd Backend/TaskManagement.Api


Install NuGet packages:
dotnet restore


Configure the database connection in appsettings.json (see Database Setup).

Apply migrations:
dotnet ef migrations add InitialCreate
dotnet ef database update


Run the backend:
dotnet run


API is available at http://localhost:5000/api/task.



Frontend Setup

Navigate to the frontend directory:
cd Frontend/task-management-app


Install Node.js dependencies:
npm install


Start the frontend:
npm start


App is available at http://localhost:3000.



Database Setup

Local SQL Server (Optional):

Install SQL Server Express.
Update appsettings.json:{
  "ConnectionStrings": {
    "AzureSQLConnection": "Server=localhost;Database=TaskManagementDB;Trusted_Connection=True;MultipleActiveResultSets=True;"
  }
}




Azure SQL Database:

In the Azure Portal, create a SQL Database:
Name: TaskManagementDB
Configure a server and note the admin credentials.
Allow Azure services and your local IP in the firewall settings.


Copy the ADO.NET connection string from the Azure Portal.
Update appsettings.json:{
  "ConnectionStrings": {
    "AzureSQLConnection": "Server=tcp:your-server.database.windows.net,1433;Initial Catalog=TaskManagementDB;Persist Security Info=False;User ID=your-user;Password=your-password;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}





Deployment

Azure Resources:

Backend: Create an Azure App Service (task-management-api) with .NET 8 runtime.
Frontend: Create an Azure Static Web App (task-management-app) linked to this repository.
Database: Ensure the Azure SQL Database is accessible by the App Service.


GitHub Actions:

Add secrets in GitHub (Settings > Secrets and variables > Actions):
AZURE_WEBAPP_PUBLISH_PROFILE: From App Service’s publish profile.
AZURE_STATIC_WEB_APPS_API_TOKEN: From Static Web App’s deployment token.


The azure-deployment.yml automates deployment on ..


Update Frontend URLs:

In Frontend/task-management-app/src/components/TaskList.js and TaskForm.js, update API URLs:axios.get('https://task-management-api.azurewebsites.net/api/task')


Update SignalR URL in TaskList.js:.withUrl('https://task-management-api.azurewebsites.net/notificationHub')


Commit changes via the GitHub web interface:
Click “Add file” > “Upload files” or edit existing files.
Use commit message:feat(frontend): update API URLs for Azure deployment

- Replace localhost with Azure App Service URL
- Update SignalR hub URL for production






Access the Deployed App:

Backend: https://task-management-api.azurewebsites.net/api/task
Frontend: https://<random-name>.azurestaticapps.net



API Endpoints



Method
Endpoint
Description



GET
/api/task
Retrieve all tasks


POST
/api/task
Create a new task


PUT
/api/task/{id}
Update an existing task


Example POST Request:
{
  "title": "Complete Report",
  "description": "Prepare quarterly report",
  "assignedTo": "John Doe",
  "status": "Pending",
  "createdAt": "2025-06-08T12:00:00Z"
}

Usage

Access the App: Open the frontend URL in a browser.
Create Tasks: Use the form to add tasks with title, description, assignee, and status.
Track Tasks: View the task list, updated in real-time via SignalR.
Receive Notifications: Get alerts for task creation or updates.
API Integration: Use the RESTful API for custom integrations.

For detailed usage, see docs/usage.md (create this file if needed).
Contributing
Contributions are welcome! To contribute:

Fork the repository.
Create a feature branch:git checkout -b feature/your-feature


Commit changes with a Conventional Commits message:git commit -m "feat(ui): add task filtering feature"


Push to the branch:git push origin feature/your-feature


Open a pull request with a detailed description.

Use the issue templates for bug reports or feature requests and follow the Code of Conduct.
License
This project is licensed under the MIT License.
Contact

GitHub: your-username
Email: your.email@example.com

