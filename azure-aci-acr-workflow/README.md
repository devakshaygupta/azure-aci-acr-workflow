# 🚀 Word Count CI/CD with ACR + ACI + GitHub Actions (Codespaces Ready)
This project demonstrates a complete CI/CD pipeline using **Azure Container Registry (ACR)**, **Azure Container Instances (ACI)**, and **GitHub Actions**, triggered by changes to a data file.

## 🎓 Project overview:

- 🧪 Demo App: A Python script counts words in specific data.txt and updates index.html dynamically.
- 🛠️ Automation: GitHub Actions runs the entire pipeline using Bash and Python scripts.
- 🐳 Docker Build: A custom Docker image is built on every change and pushed to ACR.
- 🚀 Deployment: The container is automatically deployed to ACI.
- 🔄 Trigger: The CI/CD workflow is triggered by changes to specific data.txt.
- ⚙️ Integration: Fully integrates GitHub Codespaces, GitHub Actions, Azure CLI, ACR, and ACI.
- 🌐 Live Output: The updated word count is viewable at a public URL (FQDN) after deployment.

---

## 📌 Project Highlights

- ✅ Runs entirely in **GitHub Codespaces**
- ✅ Automates word counting from `specific data.txt` using Python
- ✅ Updates `index.html` dynamically with the word count
- ✅ Builds and pushes Docker images to ACR
- ✅ Automatically deploys the updated app to ACI
- ✅ Shows the public ACI URL (FQDN) after deployment

---

## 📁 Project Structure

.github/workflows/
├── ci.yml                  # Triggers pipeline on specific data.txt changes  
└── deploy.yml              # GitHub Actions workflow for build + deploy  

apps/
└── app.py                  # Reads 'specific data.txt' and prints word count  

scripts/
├── setup.sh                # One-time Azure login + ACR + resource group  
├── run_app.sh              # Runs the Python app and captures word count  
├── update_html.sh          # Updates <p> tag in index.html  
├── git_push.sh             # Commits and pushes HTML update  
├── deploy.sh               # Deploys to Azure Container Instance (ACI)  
└── entrypoint.sh           # Runs all scripts in order  

index.html                  # Displays the updated word count  
specific data.txt           # Input file triggering the pipeline  
Dockerfile                  # Python-based container with automation logic  

---

## 🌐 Live App Access (FQDN)
http://wordcountdemo.australiaeast.azurecontainer.io