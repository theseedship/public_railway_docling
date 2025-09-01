# 🚀 Railway Docling Template - AI Document Processing Made Easy

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/docling-ocr-anything?referralCode=Z1xivh)

## 🇬🇧 English

[Docling](https://github.com/DS4SD/docling) is an open-source framework for multimodal document processing, enabling extraction, transformation, and analysis of complex documents (PDFs, images, PowerPoints, Word docs, and more).

### Why Choose Our Railway Template?

- **🔐 Built-in Authentication & IP Filtering**: Protect your instance with access control and IP allowlists
- **⚡ Optimized Performance**: Model caching for faster startup + Gzip compression (70% bandwidth reduction)
- **💰 Cost Optimization**: Runs in Railway's private network, avoiding public exposure and inter-service traffic costs
- **🛡️ Enhanced Security**: No need to make services public, significantly reducing attack surface
- **🌱 Digital Sobriety**: Use sleep mode and adjust resources for responsible management

**Perfect for:** Document automation, content extraction, OCR workflows, data processing pipelines, and AI applications.

---

## 🇫🇷 Français

[Docling](https://github.com/DS4SD/docling) est un framework open-source pour le traitement documentaire multimodal, permettant l'extraction, la transformation et l'analyse de documents complexes (PDF, images, PowerPoint, Word, etc.).

### Pourquoi Choisir Notre Template Railway ?

- **🔐 Authentification et filtrage IP intégrés** : Sécurisez votre instance avec contrôle d'accès et listes d'IP autorisées
- **⚡ Performances optimisées** : Cache des modèles pour démarrage rapide + compression Gzip (-70% bande passante)
- **💰 Optimisation des coûts** : Réseau privé Railway = pas d'exposition publique ni frais inter-services
- **🛡️ Sécurité renforcée** : Services non publics = surface d'attaque considérablement réduite
- **🌱 Sobriété numérique** : Mode veille et ajustement des ressources pour une gestion responsable

**Idéal pour :** Automatisation documentaire, extraction de contenu, workflows OCR, pipelines de traitement de données, applications IA.

---

## ✨ What Can This Do?

- **📄 Smart Document Processing**: PDFs, DOCX, PPTX, images, and audio files
- **🔍 Advanced OCR**: Extract text, tables, formulas, and maintain layout structure  
- **🎯 Export Formats**: Get results as Markdown, HTML, or JSON
- **🔒 Enterprise Security**: Dual authentication, rate limiting, security headers
- **🚀 Production Ready**: Health checks, monitoring, zero-downtime deployments
- **💡 Easy UI**: Built-in web interface for drag-and-drop processing

## 🎯 Quick Start (1-2-3 Deploy!)

### Option 1: Deploy to Railway (Recommended)

1. **Click the Deploy Button** ⬆️ (takes 2-3 minutes)
2. **Railway automatically**:
   - Forks this repo to your GitHub
   - Generates secure passwords and API tokens
   - Deploys with enterprise security enabled  
   - Gives you a live URL
3. **Start using it!** Visit your Railway URL and begin processing documents

That's it! Railway handles all the complex setup for you.

### Option 2: Local Development

```bash
# Clone the repo
git clone https://github.com/yourusername/railway-docling-template.git
cd railway-docling-template

# Generate secure credentials (creates .env file)
./scripts/generate-password.sh

# Start everything  
docker-compose up -d

# Validate it's working
./scripts/validate-deployment.sh --url http://localhost:8080
```

## 🔐 First Time Setup & Authentication

Railway will prompt you to set authentication variables. You have **two options**:

### Option 1: Simple Password (Recommended for New Users)
Just set a `PASSWORD` and Railway handles the rest:
```env
PASSWORD=your-secure-password
CADDY_USERNAME=admin  # optional, defaults to 'admin'
```
The password hash is generated automatically at startup! 🎉

### Option 2: Advanced Setup (For Existing Deployments)
If you already have a hash or want more control:
```env
CADDY_PASSWORD_HASH=$2a$14$your-generated-hash-here
CADDY_USERNAME=admin
```

### 🌐 Web Interface Access
1. Go to `https://your-app-name.railway.app/ui`
2. Login with:
   - **Username**: `admin` (or your custom username)
   - **Password**: The password you set (NOT the hash!)

### 🔌 API Access (For Developers)
```bash
# Get your API token from Railway dashboard (CADDY_AUTHORIZATION variable)
export TOKEN="your-api-token-here"

# Process a document
curl -X POST https://your-app-name.railway.app/v1/convert \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@document.pdf" \
  -F "output_format=markdown"
```

## 🆘 Authentication Troubleshooting / Dépannage

### 🇬🇧 Can't login to `/ui`?

**Simplest solution**: Just set `PASSWORD` in Railway variables!
1. Go to Railway dashboard → Variables
2. Add: `PASSWORD=your-password-here`
3. Redeploy → the hash is generated automatically
4. Login with: username `admin`, password `your-password-here`

**If you already have a `CADDY_PASSWORD_HASH`**:
- Either delete it and use `PASSWORD` instead (easier!)
- Or remember the password you used to create that hash

### 🇫🇷 Impossible de se connecter à `/ui` ?

**Solution la plus simple** : Définissez juste `PASSWORD` dans les variables Railway !
1. Allez dans Railway dashboard → Variables
2. Ajoutez : `PASSWORD=votre-mot-de-passe`
3. Redéployez → le hash est généré automatiquement
4. Connectez-vous avec : nom d'utilisateur `admin`, mot de passe `votre-mot-de-passe`

**Si vous avez déjà un `CADDY_PASSWORD_HASH`** :
- Soit supprimez-le et utilisez `PASSWORD` à la place (plus simple !)
- Soit rappelez-vous du mot de passe utilisé pour créer ce hash

## 📖 How to Use Your Document Processor

### Web Interface (Beginner-Friendly)
1. Visit `https://your-app-name.railway.app/ui`
2. Login with your credentials  
3. Upload any document (PDF, Word, image, etc.)
4. Choose output format (Markdown, HTML, JSON)
5. Click process and download results!

### API Examples (Developer-Friendly)

```bash
# Convert PDF to Markdown
curl -X POST https://your-app-name.railway.app/v1/convert \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@report.pdf" \
  -F "output_format=markdown"

# Extract text from image with OCR  
curl -X POST https://your-app-name.railway.app/v1/convert \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@scanned-doc.jpg" \
  -F "output_format=json"

# Process PowerPoint presentation
curl -X POST https://your-app-name.railway.app/v1/convert \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@presentation.pptx" \
  -F "output_format=html"
```

### Explore the APIs
- **Interactive Docs**: `https://your-app-name.railway.app/docs`
- **API Explorer**: `https://your-app-name.railway.app/scalar`  
- **OpenAPI Spec**: `https://your-app-name.railway.app/openapi.json`

## ⚙️ Configuration & Customization

Your Railway app is configured through environment variables. Here are the key ones:

| Setting | Variable | Description | Default |
|---------|----------|-------------|---------|
| Password | `PASSWORD` | Your password (auto-hashed at startup) | - |
| Password Hash | `CADDY_PASSWORD_HASH` | Pre-generated hash (advanced) | - |
| API Token | `CADDY_AUTHORIZATION` | Bearer token for API access | Auto-generated |
| Username | `CADDY_USERNAME` | Login username for `/ui` | `admin` |
| IP Filter | `ENABLE_IP_FILTER` | Enable IP restrictions | `false` |
| Allowed IPs | `ALLOWED_IPS` | IPs that can access (CIDR) | `0.0.0.0/0` |
| UI Enable | `DOCLING_SERVE_ENABLE_UI` | Show web interface | `1` (enabled) |
| Logging | `LOG_LEVEL` | How much to log | `INFO` |

### 🔄 Password Management / Gestion des mots de passe

**🇬🇧 To change your password:**
1. Go to Railway dashboard → Variables
2. **Delete or empty** `CADDY_PASSWORD_HASH`
3. **Set/update** `PASSWORD` with your new password
4. Redeploy → new hash generated automatically!

**🇫🇷 Pour changer votre mot de passe :**
1. Allez dans Railway dashboard → Variables
2. **Supprimez ou videz** `CADDY_PASSWORD_HASH`
3. **Définissez/mettez à jour** `PASSWORD` avec votre nouveau mot de passe
4. Redéployez → le hash est généré automatiquement !

**🇬🇧 How password management works:**
The system uses two variables: `PASSWORD` (plain text) and `CADDY_PASSWORD_HASH` (encrypted hash).
- When you set `PASSWORD`, the system automatically generates the secure hash at startup
- If `CADDY_PASSWORD_HASH` exists, it takes priority (safety mechanism to prevent accidental changes)
- To change password: delete the hash variable, set new PASSWORD, and redeploy

**🇫🇷 Comment fonctionne la gestion des mots de passe :**
Le système utilise deux variables : `PASSWORD` (texte clair) et `CADDY_PASSWORD_HASH` (hash chiffré).
- Quand vous définissez `PASSWORD`, le système génère automatiquement le hash sécurisé au démarrage
- Si `CADDY_PASSWORD_HASH` existe, il a la priorité (mécanisme de sécurité contre les changements accidentels)
- Pour changer : supprimez la variable hash, définissez le nouveau PASSWORD, et redéployez

### Optional Security Features

**IP Allowlist**: Restrict access to specific IPs
```env
ENABLE_IP_FILTER=true
ALLOWED_IPS=192.168.1.0/24,10.0.0.5/32
```


## 🚀 Railway-Specific Optimizations

### Serverless Performance Tips

**ML Model Caching**: Add these volumes in Railway dashboard to avoid re-downloading AI models:
```
Volume Mount Points:
- /app/models → docling-models  
- /app/cache → docling-cache
```

**Benefits**: First start ~137s (downloads models), subsequent starts ~10s (uses cache)

**Models Cached**: LayoutLM (~500MB), TableFormer (~200MB), OCR models (~100MB)

### Cost Optimization
- **Gzip enabled**: Reduces bandwidth by ~70%
- **Health checks**: Bypass auth for monitoring
- **Resource limits**: Prevents runaway costs
- **Private networking**: Use Railway's internal URLs between services

## 🛡️ Security Features (Enterprise Grade)

This template includes comprehensive security out of the box:

### Authentication Layers
- **API Endpoints** (`/v1/*`): Bearer token authentication
- **Web Interface** (`/ui`): Username/password with bcrypt hashing
- **Admin Routes**: Protected by basic auth

### Security Headers
Every response includes:
- **HSTS**: Forces HTTPS with 1-year expiry
- **CSP**: Prevents code injection attacks  
- **X-Frame-Options**: Blocks clickjacking
- **X-Content-Type-Options**: Prevents MIME sniffing


### Container Security  
- **Non-root user**: Containers run unprivileged
- **Alpine Linux**: Minimal attack surface
- **Read-only configs**: Configuration files protected
- **Resource constraints**: CPU/memory limits enforced

## 🔧 Troubleshooting Common Issues

### "Unauthorized" API Errors
```bash
# ❌ Wrong: Missing Bearer token
curl https://your-app.railway.app/v1/convert

# ✅ Correct: Include Authorization header
curl -H "Authorization: Bearer YOUR_TOKEN" https://your-app.railway.app/v1/convert
```

### "Rate Limited" Errors
- **Cause**: Too many requests too quickly
- **Solution**: Add delays between requests or increase limits in environment variables

### "File Too Large" Errors  
- **Default Limit**: 100MB for documents, 50MB for API
- **Solution**: Adjust `MAX_REQUEST_SIZE_DOCS` environment variable

### App Won't Start
1. Check Railway logs for startup errors
2. Verify environment variables are set
3. Run validation script: `./scripts/validate-deployment.sh --url https://your-app.railway.app`

### Models Keep Re-downloading
- **Problem**: No persistent volumes configured
- **Solution**: Add volume mounts in Railway dashboard (see [optimization section](#railway-specific-optimizations))

## 📊 Monitoring Your Deployment

### Health Endpoints
- **Basic Health**: `GET /health` (returns 200 if running)
- **Detailed Status**: `GET /ready` (validates backend connectivity)
- **Metrics**: Available via Caddy's built-in metrics

### What to Monitor
- **Failed logins**: High numbers may indicate attack
- **Rate limit hits**: May need to adjust limits  
- **Response times**: Should be under 5 seconds
- **Error rates**: Keep 4xx under 10%, 5xx under 5%

### Logs Access
View logs in Railway dashboard or via CLI:
```bash
railway logs --follow
```

## 🧪 Testing Your Setup

### Quick Validation
```bash
# Download validation script
curl -O https://raw.githubusercontent.com/yourusername/railway-docling-template/main/scripts/validate-deployment.sh

# Test your deployment
chmod +x validate-deployment.sh  
./validate-deployment.sh --url https://your-app-name.railway.app --token your-api-token
```

### Manual Tests
```bash
# Test health endpoint
curl https://your-app-name.railway.app/health

# Test authentication  
curl -u admin:your-password https://your-app-name.railway.app/ui

# Test API with a small file
curl -X POST https://your-app-name.railway.app/v1/convert \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@small-test.pdf" \
  -F "output_format=json"
```

## 🔄 Updates & Maintenance

### Regular Maintenance
- **Weekly**: Review authentication logs in Railway dashboard
- **Monthly**: Rotate API tokens (`CADDY_AUTHORIZATION`)
- **Quarterly**: Update passwords (`CADDY_PASSWORD_HASH`)

### Updating the Template
Railway automatically deploys when you push changes to your forked repo. The template includes:
- **Automated security scanning**: Checks for vulnerabilities
- **Health validation**: Ensures updates don't break functionality  
- **Rolling deployments**: Zero-downtime updates

## 📚 API Reference

### Document Conversion Endpoint
```http
POST /v1/convert
Authorization: Bearer YOUR_TOKEN
Content-Type: multipart/form-data

Parameters:
- file: Document file (PDF, DOCX, PPTX, images, audio)
- output_format: markdown | html | json
- extract_tables: true | false (optional)
- extract_images: true | false (optional)
```

### Health Check Endpoints
```http
GET /health          # Basic health (always returns 200 if running)
GET /ready           # Detailed health (validates backend)
GET /metrics         # Prometheus metrics (if enabled)
```

### Response Formats
```json
{
  "status": "success",
  "document_type": "pdf",
  "pages": 5,
  "content": "...",
  "tables": [...],
  "images": [...]
}
```

## 🤝 Support & Contributing

### Getting Help
- **📖 Documentation**: Full docs in this repository's wiki
- **🐛 Bug Reports**: [Create GitHub issue](https://github.com/yourusername/railway-docling-template/issues)
- **💬 Questions**: Use GitHub Discussions
- **🚂 Railway Help**: [Railway Documentation](https://docs.railway.app)

### Contributing
1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run security validation (`./scripts/validate-deployment.sh`)
5. Submit a pull request

### Reporting Security Issues
🚨 **Do not create public issues for security vulnerabilities**

Email security details to: security@yourdomain.com

We'll respond within 48 hours and work to resolve critical issues within 7 days.

## 📄 License & Credits

This template is MIT licensed - see [LICENSE](LICENSE) file for details.

**Built with**:
- [Docling](https://github.com/DS4SD/docling) by IBM Research (Document AI)
- [Caddy](https://caddyserver.com) (Reverse proxy & security)
- [Railway](https://railway.app) (Hosting platform)

---

## 🎯 What's Next?

After deploying your Docling service:

1. **🧪 Test it**: Upload a PDF to `/ui` and see the magic happen
2. **🔌 Integrate**: Use the API in your applications
3. **📈 Scale**: Railway auto-scales based on usage  
4. **🛡️ Secure**: Review security settings for your use case
5. **📊 Monitor**: Set up alerts for your application

**Made with ❤️ for the Railway community**

Version 1.0.0 | [View on GitHub](https://github.com/yourusername/railway-docling-template) | [Deploy to Railway](https://railway.com/new/template/docling-ocr-anything?referralCode=Z1xivh)