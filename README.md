## 🚀 Word Count CI/CD with ACR + ACI + GitHub Actions
This project demonstrates a complete CI/CD pipeline using **Azure Container Registry (ACR)**, **Azure Container Instances (ACI)**, and **GitHub Actions**, triggered by changes to a data file.

### 📌 Project Highlights:
- ⚙️ Integration: Fully integrates (GitHub Actions + ACR + ACI) CI/CD pipeline.
- 🔐 Setup: Configure Azure (Resource Group, ACR, Service Principal) and set GitHub Actions secrets.
- 🧪 Demo App: A Python script counts words in specific data.txt 
- 🛠️ Automation: GitHub Actions runs the entire pipeline using Bash and Python scripts.
- 🐳 Docker Build: A custom Docker image is built on every change and pushed to ACR.
- 🚀 Deployment: The container is automatically deployed to ACI.
- 🔄 Trigger: The CI/CD workflow is triggered by changes to specific data.txt.
- ✅ Sucess: Dynamically update `index.html` with the word count and `README` with the curent 🌐FQDN
- 🌐 Live Output: The updated word count is viewable at a public URL (FQDN) after deployment.

---

### 📁 Project Structure

.github/workflows/\
│\
├── apps/\
│   &ensp;&ensp;&ensp;└── app.py          
├── scripts/\
│   &ensp;&ensp;&ensp;├── setup.sh   (One-time script - initialization)                  
│   &ensp;&ensp;&ensp;├── update_html.sh\
│   &ensp;&ensp;&ensp;├── update_readme.sh         
│   &ensp;&ensp;&ensp;├── git_push.sh        
│   &ensp;&ensp;&ensp;├── deploy.sh            
│   &ensp;&ensp;&ensp;└── entrypoint.sh  
│     
├── ci.yml                    
└── deploy.yml

index.html                 
specific data.txt           
Dockerfile\
.gitignore                

---

### 🌐 Live App Access (FQDN)
http://wordcountdemo-14819494588.australiaeast.azurecontainer.io

