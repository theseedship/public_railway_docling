[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/docling-ocr-anything?referralCode=Z1xivh)
[![Security Scan](https://github.com/yourusername/railway-docling-template/actions/workflows/security.yml/badge.svg)](https://github.com/yourusername/railway-docling-template/actions/workflows/security.yml)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://hub.docker.com/r/ds4sd/docling-serve)

# 🚀 Railway Docling OCR Template - Enterprise Ready

Production-ready, secure deployment template for [Docling](https://github.com/DS4SD/docling) - a powerful document processing tool that parses PDFs, DOCX, PPTX, images, and audio files with advanced OCR capabilities, Visual Language Models, and ASR for audio transcription.

## ✨ Features

### 🔒 Enterprise Security
- **Dual Authentication**: Bearer tokens for API, Basic Auth for UI
- **Security Headers**: HSTS, CSP, X-Frame-Options, and more
- **Rate Limiting**: Configurable per-endpoint and global limits
- **Non-root Containers**: Enhanced container security
- **Automated Security Scanning**: GitHub Actions workflows

### 📄 Document Processing
- **Multi-format Support**: PDF, DOCX, PPTX, images, audio files
- **Advanced OCR**: Layout analysis, table extraction, formula recognition
- **Visual Language Models**: Deep document understanding
- **Audio Transcription**: ASR capabilities for audio files
- **Export Options**: Markdown, HTML, JSON formats

### 🏗️ Production Ready
- **Health Checks**: Automated monitoring endpoints
- **Zero-downtime Deployments**: Rolling updates with health validation
- **Resource Management**: Configurable CPU/memory limits
- **Logging & Monitoring**: Structured JSON logging
- **Docker Compose**: Local development environment

## 🚀 Quick Start

### Deploy to Railway (Recommended)

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/docling-ocr-anything?referralCode=Z1xivh)

Click the button above and Railway will:
1. Fork this repository to your GitHub account
2. Deploy the services automatically
3. Generate secure credentials
4. Provide you with a public URL

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/railway-docling-template.git
   cd railway-docling-template
   ```

2. **Generate secure credentials**
   ```bash
   chmod +x scripts/generate-password.sh
   ./scripts/generate-password.sh
   ```

3. **Create environment file**
   ```bash
   cp .env.example .env
   # Edit .env with your generated credentials
   ```

4. **Start services**
   ```bash
   docker-compose up -d
   ```

5. **Validate deployment**
   ```bash
   ./scripts/validate-deployment.sh --url http://localhost:8080
   ```

## 📖 Usage

### API Authentication

Call API endpoints with Bearer token authentication:

```bash
# Set your token (get from Railway dashboard or .env file)
export TOKEN="your-bearer-token-here"

# Upload and process a document
curl -X POST https://your-app.railway.app/v1/convert \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@document.pdf" \
  -F "output_format=markdown"
```

### UI Access

1. Navigate to `https://your-app.railway.app/ui`
2. Enter username and password (configured in environment variables)
3. Use the Gradio interface for document processing

### Documentation

- **API Documentation**: `https://your-app.railway.app/docs`
- **Interactive API**: `https://your-app.railway.app/scalar`
- **OpenAPI Spec**: `https://your-app.railway.app/openapi.json`

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `CADDY_AUTHORIZATION` | Bearer token for API auth | Auto-generated | Yes |
| `CADDY_USERNAME` | Basic auth username | `admin` | Yes |
| `CADDY_PASSWORD_HASH` | Bcrypt password hash | - | Yes |
| `ENABLE_IP_FILTER` | Enable IP filtering | `false` | No |
| `ALLOWED_IPS` | IP allowlist (CIDR format) | `0.0.0.0/0` (all) | No |
| `DOCLING_SERVE_ENABLE_UI` | Enable Gradio UI | `1` | No |
| `LOG_LEVEL` | Logging verbosity | `INFO` | No |

See [.env.example](.env.example) for complete configuration options.

### Security Configuration

#### Generate Credentials

```bash
# Interactive credential generator
./scripts/generate-password.sh

# Options:
# 1. Generate password hash only
# 2. Generate API token only
# 3. Generate both (recommended)
# 4. Generate random password with hash
```

#### Rate Limiting

Default rate limits (configurable in Caddyfile):
- **Global**: 1000 requests/minute
- **API per IP**: 100 requests/minute
- **Docs per IP**: 30 requests/minute

#### Security Headers

All responses include:
- HSTS with preloading
- CSP policy
- X-Frame-Options: DENY
- X-Content-Type-Options: nosniff
- Custom Referrer and Permissions policies

## 📊 Monitoring

### Health Checks

- **Basic Health**: `GET /health` - Returns 200 if Caddy is running
- **Ready Check**: `GET /ready` - Validates backend connectivity
- **Metrics**: Available via Caddy's metrics endpoint

### Logging

Structured JSON logging to stdout with configurable levels:
- `DEBUG`: Verbose debugging information
- `INFO`: Standard operational logs
- `WARN`: Warning messages
- `ERROR`: Error conditions

### Validation Script

Run comprehensive deployment validation:

```bash
./scripts/validate-deployment.sh \
  --url https://your-app.railway.app \
  --token your-api-token
```

## 🛡️ Security

This template implements enterprise-grade security. See [SECURITY.md](SECURITY.md) for:
- Security features and best practices
- Vulnerability reporting process
- Compliance standards
- Security audit checklist

### Key Security Features

1. **Authentication**: Dual-layer with Bearer tokens and Basic Auth
2. **Container Security**: Non-root user, Alpine base, read-only configs
3. **Network Security**: Rate limiting, security headers, CORS control
4. **Automated Scanning**: Daily vulnerability scans via GitHub Actions

## 🧪 Testing

### Local Testing

```bash
# Run security validation
docker-compose up -d
./scripts/validate-deployment.sh

# Run specific tests
docker-compose exec caddy caddy validate --config /etc/caddy/Caddyfile
```

### CI/CD Pipeline

GitHub Actions workflows included:
- **Security scanning**: Container vulnerabilities, dependencies, secrets
- **Configuration validation**: Syntax checking, security headers
- **Automated testing**: Health checks, authentication, rate limiting

## 📚 API Examples

### Convert PDF to Markdown

```bash
curl -X POST https://your-app.railway.app/v1/convert \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@document.pdf" \
  -F "output_format=markdown"
```

### Process Image with OCR

```bash
curl -X POST https://your-app.railway.app/v1/ocr \
  -H "Authorization: Bearer $TOKEN" \
  -F "image=@scan.jpg"
```

### Extract Tables from Document

```bash
curl -X POST https://your-app.railway.app/v1/extract/tables \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@report.pdf"
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run security validation
5. Submit a pull request

## 📝 License

This template is MIT licensed. See [LICENSE](LICENSE) file for details.

Docling is licensed under [MIT License](https://github.com/DS4SD/docling/blob/main/LICENSE).

## 🆘 Support

- **Documentation**: [Full documentation](https://github.com/yourusername/railway-docling-template/wiki)
- **Issues**: [GitHub Issues](https://github.com/yourusername/railway-docling-template/issues)
- **Security**: See [SECURITY.md](SECURITY.md) for reporting vulnerabilities
- **Railway Support**: [Railway Documentation](https://docs.railway.app)

## 🚀 Railway Serverless Optimization

### Volume Configuration for ML Models

For serverless deployments, configure persistent volumes to cache ML models and avoid re-downloading on each cold start:

```yaml
# In Railway dashboard, add these volumes to docling-serve:
volumes:
  - mount: /app/models
    name: docling-models
  - mount: /app/cache
    name: docling-cache
```

This caches:
- **LayoutLM models** (~500MB) - Document layout analysis
- **TableFormer models** (~200MB) - Table extraction
- **OCR models** (~100MB) - Text recognition
- **Processed documents** - Faster re-processing

**First start**: ~137 seconds (model download)  
**Subsequent starts**: ~10 seconds (models cached)

### IP Filtering

Restrict access to specific IP addresses:

```bash
# Enable IP filtering
ENABLE_IP_FILTER=true
# Allow specific IPs (CIDR format)
ALLOWED_IPS="192.168.1.0/24,10.0.0.5/32"
```

### Performance Features

- **Gzip Compression**: Enabled by default (reduces payload by ~70%)
- **HTTP/2**: Enabled for multiplexing
- **Health checks**: Bypass authentication for monitoring

## 🎯 Roadmap

- [ ] JWT token authentication support
- [ ] Multi-tenant isolation
- [ ] S3/Cloud storage integration
- [ ] Webhook notifications
- [ ] Advanced queue management
- [ ] Prometheus metrics endpoint
- [ ] OpenTelemetry tracing

## 🏆 Credits

- [Docling](https://github.com/DS4SD/docling) by IBM Research
- [Caddy](https://caddyserver.com) for reverse proxy
- [Railway](https://railway.app) for hosting platform

---

**Version**: 1.0.0 | **Last Updated**: January 2024

Made with ❤️ for the Railway community