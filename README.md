# LWC Meetings Manager

This project is a Salesforce development workspace connected to a GitHub repository. It includes Lightning Web Components (LWC), Apex classes, triggers, and configuration for managing Meetings inside Salesforce.

## 📁 Project Structure

```
C:\lwc-meetings-manager
│
├── force-app
│   └── main
│       └── default
│           ├── classes
│           ├── lwc
│           ├── objects
│           └── triggers
│
├── sfdx-project.json
└── README.md
```

## 🚀 Features

* Lightning Web Components for managing meetings
* Apex logic supporting meeting creation, updates, and business rules
* Trigger handlers and helper classes
* Integration with external systems (e.g., MINHALI, GetDataFromCorporateOrPrivateCusto)
* Email notifications on create/update
* Batch processes (e.g., ownership updates)

## 🛠️ Setup Instructions

1. Clone the repository:

   ```bash
   git clone <repository-url>
   ```

2. Open the project in VS Code:

   ```bash
   code lwc-meetings-manager
   ```

3. Authorize org:

   ```bash
   sfdx force:auth:web:login -a <alias>
   ```

4. Deploy metadata to org:

   ```bash
   sfdx force:source:deploy -p force-app
   ```

## 📦 Git Commands

### Add remote origin

If your project has no remote branch:

```bash
git remote add origin <repo-url>
```

### Push the main branch to remote

```bash
git push --set-upstream origin main
```

### Standard workflow

```bash
git add .
git commit -m "Your message"
git push
```

## 🧪 Testing

Run Apex tests from VSCode or CLI:

```bash
sfdx force:apex:test:run -r human
```

## 📚 Requirements

* Salesforce CLI
* VSCode with Salesforce extensions
* Git

---

If you want I can also generate a more detailed professional README with badges, screenshots, and instructions.
