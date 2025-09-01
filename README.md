# 🚀 Railway Docling Template - AI Document Processing Made Easy

Transform any document into structured data with enterprise-grade security. This Railway template deploys [IBM's Docling](https://github.com/DS4SD/docling) - a powerful AI that can read PDFs, images, Word docs, PowerPoints, and even audio files with OCR, layout analysis, and transcription capabilities.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/docling-ocr-anything?referralCode=Z1xivh)

**Perfect for:** Document automation, content extraction, OCR workflows, data processing pipelines, and AI applications that need to understand documents.

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

When Railway deploys your app, you'll get **two ways to access it**:

### 🌐 Web Interface (Easy Start)
1. Go to `https://your-app-name.railway.app/ui`
2. Login with:
   - **Username**: `admin` 
   - **Password**: Check your Railway environment variables for `CADDY_PASSWORD_HASH` - [see auth troubleshooting](#-authentication-troubleshooting) below

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

## 🆘 Authentication Troubleshooting

**Problem**: Can't login to `/ui`?

**Solution**: You need the actual password, not the password hash!

1. **Quick Fix**: Try these common passwords with username `admin`:
   - `changeme123`
   - `admin` 
   - `password`
   - `docling`

2. **Set New Password**: 
   ```bash
   # Generate a password hash for "mynewpassword"
   echo "mynewpassword" | docker run -i --rm caddy:alpine caddy hash-password
   
   # Copy the output hash to Railway's CADDY_PASSWORD_HASH variable
   # Then login with username: admin, password: mynewpassword
   ```

3. **Generate Random Password**: Use the script to create secure credentials:
   ```bash
   ./scripts/generate-password.sh  # Choose option 4
   ```

**Remember**: The hash goes in the environment variable, the actual password is what you type when logging in!

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
| API Token | `CADDY_AUTHORIZATION` | Bearer token for API access | Auto-generated |
| Username | `CADDY_USERNAME` | Login username for `/ui` | `admin` |
| Password | `CADDY_PASSWORD_HASH` | Hashed password for `/ui` | Auto-generated |
| UI Enable | `DOCLING_SERVE_ENABLE_UI` | Show web interface | `1` (enabled) |
| Logging | `LOG_LEVEL` | How much to log | `INFO` |

### Optional Security Features

**IP Allowlist**: Restrict access to specific IPs
```env
ENABLE_IP_FILTER=true
ALLOWED_IPS=192.168.1.0/24,10.0.0.5/32
```

**Custom Rate Limits**: Prevent abuse
```env  
RATE_LIMIT_GLOBAL=1000       # Requests per minute globally
RATE_LIMIT_API_PER_IP=100    # API requests per IP per minute
RATE_LIMIT_DOCS_PER_IP=30    # Docs requests per IP per minute
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

### Rate Limiting
- **Global**: 1000 requests/minute
- **Per-IP API**: 100 requests/minute  
- **Documentation**: 30 requests/minute per IP

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