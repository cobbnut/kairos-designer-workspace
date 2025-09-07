# Kairos Designer

**Full-Stack Application**: React Frontend + Python Flask Backend

Kairos Designer is a unified full-stack application consisting of a React frontend and Python Flask backend, designed for integrated development and deployment.

## 🚀 Quick Start

### Prerequisites
- **Node.js** (for frontend)
- **Python 3.8+** (for backend)
- **PostgreSQL** (database)
- **Redis** (optional, for caching)

### Running the Complete Application

1. **Clone and setup the workspace:**
   ```bash
   git clone <your-repo-url>
   cd 103_kairos_designer
   ```

2. **Start the backend:**
   ```bash
   cd kdes
   # Activate virtual environment (Windows)
   venv\Scripts\activate
   # Install dependencies
   pip install -r requirements.txt
   # Start Flask server
   python run.py
   ```

3. **Start the frontend (new terminal):**
   ```bash
   cd kdes-fe
   npm install
   npm run dev
   ```

4. **Access the application:**
   - Frontend: `http://localhost:3000` (Vite dev server)
   - Backend API: `https://kairos:5002` (Flask with SSL)

## 📁 Project Structure

```
103_kairos_designer/
├── kdes-fe/          # React Frontend (Vite + JavaScript)
│   ├── src/
│   │   ├── api/      # 🔥 CRITICAL: Centralized API layer
│   │   ├── components/
│   │   ├── contexts/
│   │   ├── hooks/
│   │   └── pages/
│   └── package.json
├── kdes/             # Python Flask Backend
│   ├── kairos/
│   │   ├── blueprints/
│   │   ├── models/
│   │   └── app.py
│   └── run.py
└── README.md         # This file
```

## 🔧 Technology Stack

### Frontend (kdes-fe)
- **React 18** + **Vite** (JavaScript/ES modules)
- **Bootstrap 5** + **React Bootstrap** (UI framework)
- **React Router DOM v7** (routing)
- **Socket.IO** (real-time communication)
- **Uppy** (file uploads)
- **Lexical/Quill** (rich text editing)
- **@dnd-kit** (drag & drop)

### Backend (kdes)
- **Python Flask** + **SQLAlchemy** (web framework + ORM)
- **PostgreSQL** (primary database)
- **Flask-SocketIO** (real-time communication)
- **JWT** (authentication)
- **OpenAI API** (AI integration)
- **Redis** (caching - optional)

## 🏗️ Development Guidelines

### 🚨 CRITICAL: API Architecture Rules

**ALWAYS use ApiBroker pattern for API calls:**

```javascript
// ✅ CORRECT: Use ApiBroker via functional modules
import ApiBroker from "../api/apiBroker";
const apiBroker = new ApiBroker("/api");

export const newApiCall = async (params) => {
  return apiBroker.request("/endpoint", "POST", data);
};

// ❌ FORBIDDEN: Never make direct fetch() calls
```

### API Organization
- `authApi.js` - Authentication & user management
- `functionalApi.js` - Core business logic
- `assistantApi.js` - AI assistant features
- `contentApi.js` - Content management
- `sysadminApi.js` - System administration

### Full-Stack Development Process
1. **Design API contract** between frontend and backend
2. **Implement Flask blueprint** (backend endpoints)
3. **Add API calls** using ApiBroker pattern (frontend)
4. **Create UI components** that consume the APIs
5. **Add Socket.IO** for real-time updates if needed
6. **Test complete user flow**

## 🔒 Security Features
- **HTTPS/SSL** - All communication encrypted
- **JWT Authentication** - Managed via ApiBroker
- **File Security** - UUID-based authenticated downloads
- **CORS** - Configured for cross-origin requests

## 🤖 AI Integration
- **OpenAI API** integration for content assistance
- **Smart suggestions** and automation features
- **Natural language processing** capabilities

## 📚 Documentation
- See `.warp.md` for detailed architectural rules
- Frontend docs: `kdes-fe/README.md`
- Backend docs: `kdes/` Python docstrings

## 🐛 Troubleshooting

### Common Issues
1. **SSL Certificate errors**: Ensure certificates are properly configured in `kdes/kairos/config/`
2. **CORS errors**: Check backend CORS configuration
3. **Database connection**: Verify PostgreSQL is running and connection settings
4. **Port conflicts**: Backend runs on `5002`, frontend on `3000` (Vite default)

## 🤝 Contributing
This is a unified workspace project. When implementing features:
- **Plan both frontend and backend changes together**
- **Follow the ApiBroker architecture strictly**
- **Comment code richly for legibility**
- **Test the complete user journey**

---

**Note**: This project uses HTTPS in development with self-signed certificates. You may need to accept browser security warnings during local development.
