# 🚀 Railway Docling Template

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/docling-ocr-anything?referralCode=Z1xivh)

## 🇬🇧 English
[Docling](https://github.com/DS4SD/docling) is an AI framework for document processing (PDFs, images, PowerPoint, Word) with OCR, table extraction, and format conversion.

**Why this Railway template?**
- 🔑 **Ultra-simple password**: Just set PASSWORD - auto-encrypted, change anytime!
- 🔐 **Built-in security**: Authentication + IP filtering ready
- ⚡ **Optimized for Railway**: Model caching, Gzip compression, instant deploy
- 💰 **Cost-effective**: Private network, no public exposure needed

## 🇫🇷 Français
[Docling](https://github.com/DS4SD/docling) est un framework IA pour le traitement documentaire (PDF, images, PowerPoint, Word) avec OCR, extraction de tableaux et conversion de formats.

**Pourquoi ce template Railway ?**
- 🔑 **Mot de passe ultra-simple** : Définissez PASSWORD - chiffré automatiquement, changez quand vous voulez !
- 🔐 **Sécurité intégrée** : Authentification + filtrage IP prêts
- ⚡ **Optimisé pour Railway** : Cache des modèles, compression Gzip, déploiement instant
- 💰 **Économique** : Réseau privé, pas d'exposition publique nécessaire

---

## ⚡ Quick Start

1. **Click Deploy Button** ⬆️ (2-3 minutes)
2. **Set PASSWORD** in Railway variables  
3. **Access** your app:
   - 🎨 **UI**: `https://your-app.railway.app/ui` (login with admin/your-password)
   - 📖 **API Docs**: `https://your-app.railway.app/docs`
   - 🔧 **API Explorer**: `https://your-app.railway.app/scalar`

## 🔐 Authentication

### Simple Setup (Recommended)
Set in Railway Variables:
```env
PASSWORD=your-secure-password
```
Login with: `admin` / `your-secure-password`

**Troubleshooting:** Can't login? Just set `PASSWORD` variable in Railway and redeploy.

### API Access
```bash
# Get token from CADDY_AUTHORIZATION variable
curl -X POST https://your-app.railway.app/v1/convert \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "file=@document.pdf" \
  -F "output_format=markdown"
```

## 🎯 Core Features
- **📄 Process**: PDFs, DOCX, PPTX, images, audio
- **🔍 Extract**: Text, tables, formulas with OCR
- **📤 Export**: Markdown, HTML, JSON
- **🔒 Secure**: Authentication, rate limiting, HTTPS
- **💡 Easy UI**: Drag-and-drop web interface

## ⚙️ Configuration

| Variable | Purpose | Default |
|----------|---------|---------|
| `PASSWORD` | Your login password | - |
| `CADDY_USERNAME` | Login username | `admin` |
| `CADDY_AUTHORIZATION` | API Bearer token | Auto-generated |
| `ENABLE_IP_FILTER` | Restrict by IP | `false` |
| `ALLOWED_IPS` | Allowed IP ranges | `0.0.0.0/0` |

### Password Management
**🇬🇧 Change password:** Just update `PASSWORD` → Redeploy  
**🇫🇷 Changer mot de passe:** Modifiez `PASSWORD` → Redéployez

## 🚀 Railway Optimization

**Add volumes for model caching:**
```
/app/models → docling-models
/app/cache → docling-cache
```
**Result:** 137s first start → 10s subsequent starts

## 🛡️ Security Features
- Bearer token API authentication  
- bcrypt password hashing
- Security headers (HSTS, CSP, X-Frame-Options)
- Rate limiting & IP filtering
- Non-root containers

## 📚 API Endpoints

**Convert Document:**
```bash
POST /v1/convert
Authorization: Bearer TOKEN
Content-Type: multipart/form-data

# Parameters: file, output_format (markdown|html|json)
```

**Health Checks:**
- `GET /health` - Basic status
- `GET /ready` - Detailed status  
- `GET /docs` - API documentation

## 🔧 Common Issues

**"Unauthorized" errors:** Include `Authorization: Bearer TOKEN` header  
**Models re-downloading:** Add volume mounts in Railway dashboard  
**App won't start:** Check Railway logs and environment variables

---

**Built with:** [Docling](https://github.com/DS4SD/docling) • [Caddy](https://caddyserver.com) • [Railway](https://railway.app)

[GitHub](https://github.com/yourusername/railway-docling-template) • [Deploy](https://railway.com/new/template/docling-ocr-anything?referralCode=Z1xivh)