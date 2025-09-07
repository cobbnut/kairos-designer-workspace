# Kairos Designer - Development Guide

## 🛠️ Development Environment Setup

### Initial Setup (One Time)

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd 103_kairos_designer
   ```

2. **Backend Setup (kdes):**
   ```bash
   cd kdes
   
   # Create virtual environment (if not exists)
   python -m venv venv
   
   # Activate virtual environment
   # Windows PowerShell:
   venv\Scripts\Activate.ps1
   # Windows CMD:
   venv\Scripts\activate.bat
   
   # Install Python dependencies
   pip install -r requirements.txt
   ```

3. **Frontend Setup (kdes-fe):**
   ```bash
   cd ../kdes-fe
   
   # Install Node.js dependencies
   npm install
   ```

### Daily Development Workflow

#### Option 1: Manual Start (Two Terminals)

**Terminal 1 - Backend:**
```bash
cd kdes
venv\Scripts\Activate.ps1  # Activate Python virtual environment
python run.py              # Starts Flask server on https://kairos:5002
```

**Terminal 2 - Frontend:**
```bash
cd kdes-fe
npm run dev                # Starts Vite dev server (usually port 3000)
```

#### Option 2: Using Development Scripts (Recommended)

See `scripts/` directory for automated startup scripts.

## 🏗️ Architecture Overview

### Communication Flow
```
Frontend (React + Vite)  ←→  Backend (Flask + Python)
     ↓                              ↓
 Browser (port 3000)      ←→  API Server (port 5002)
     ↓                              ↓
 ApiBroker Pattern        ←→  Flask Blueprints
     ↓                              ↓
 Socket.IO Client         ←→  Flask-SocketIO
                                    ↓
                            PostgreSQL Database
```

### Key Development Principles

1. **API-First Development:**
   - Design the API contract first
   - Implement backend endpoints in Flask blueprints
   - Create frontend API calls using ApiBroker pattern
   - Never make direct fetch() calls

2. **Real-Time Updates:**
   - Use Socket.IO for live data synchronization
   - Emit events from backend on data changes
   - Listen to events in React components

3. **Rich Code Comments:**
   - Always comment code extensively for maintainability
   - Update existing comments when modifying code
   - Document complex business logic and architectural decisions

## 🔧 Development Tools

### Backend Tools (Python)
- **Flask**: Web framework with hot reloading
- **SQLAlchemy**: Database ORM with query debugging
- **Flask-SocketIO**: Real-time WebSocket communication
- **PyJWT**: JSON Web Token authentication

### Frontend Tools (JavaScript)
- **Vite**: Fast development server with hot module replacement
- **React DevTools**: Component debugging and state inspection
- **Browser DevTools**: Network monitoring and console debugging
- **ESLint**: Code quality and style enforcement

### Development Extensions (Recommended)
- **VS Code**: Python, JavaScript, and React extensions
- **Browser**: React Developer Tools, Redux DevTools
- **Database**: pgAdmin for PostgreSQL management

## 📁 File Organization Best Practices

### Frontend (kdes-fe/src/)
```
src/
├── api/              # 🚨 CRITICAL: All API calls via ApiBroker
│   ├── apiBroker.js  # Core API communication class
│   ├── authApi.js    # Authentication APIs
│   ├── functionalApi.js  # Core business logic APIs  
│   ├── assistantApi.js   # AI assistant APIs
│   ├── contentApi.js     # Content management APIs
│   └── sysadminApi.js    # System administration APIs
├── components/       # Reusable UI components
├── contexts/         # React Context providers
├── hooks/           # Custom React hooks
├── layouts/         # Page layout components
├── pages/           # Route-level page components
└── utils/           # Utility functions
```

### Backend (kdes/kairos/)
```
kairos/
├── blueprints/      # Flask route blueprints (API endpoints)
├── models/          # SQLAlchemy database models
├── config/          # Configuration files and SSL certificates
├── utils/           # Utility functions and helpers
└── app.py          # Main Flask application factory
```

## 🚀 Feature Development Workflow

### Adding a New Feature

1. **Plan the Feature:**
   - Define requirements for both frontend and backend
   - Design the API contract (endpoints, data structures)
   - Identify any database schema changes needed

2. **Backend Implementation:**
   ```bash
   cd kdes
   # Create/modify database models if needed
   # Add Flask blueprint with new API endpoints
   # Implement business logic with rich comments
   # Test endpoints manually or with unit tests
   ```

3. **Frontend Implementation:**
   ```bash
   cd kdes-fe
   # Add API calls to appropriate functional API module
   # Create/modify React components
   # Add any new contexts or hooks needed
   # Test UI interactions and API integration
   ```

4. **Integration Testing:**
   - Test complete user workflows
   - Verify real-time updates via Socket.IO
   - Check error handling and edge cases
   - Validate security (authentication, authorization)

### Common Development Tasks

#### Adding a New API Endpoint

**Backend (Flask Blueprint):**
```python
# In kdes/kairos/blueprints/your_blueprint.py
@blueprint.route('/api/your-endpoint', methods=['POST'])
@jwt_required()  # Ensure authentication if needed
def your_endpoint():
    """
    Rich comment describing what this endpoint does,
    expected parameters, return values, and any side effects.
    """
    # Implementation with extensive comments
    return jsonify({"result": "success"})
```

**Frontend (API Module):**
```javascript
// In kdes-fe/src/api/functionalApi.js
/**
 * Rich comment describing the purpose of this API call,
 * its parameters, return values, and when to use it.
 */
export const yourApiCall = async (params) => {
  return apiBroker.request("/your-endpoint", "POST", params);
};
```

#### Database Schema Changes

1. **Modify SQLAlchemy models** in `kdes/kairos/models/`
2. **Create migration scripts** if using Flask-Migrate
3. **Update API endpoints** to handle new data structures
4. **Update frontend** to work with new data formats

## 🐛 Debugging and Troubleshooting

### Backend Debugging
- **Flask Debug Mode**: Automatic reloading and error pages
- **Console Logging**: Use `app.logger.info()` for debugging
- **Database Queries**: Enable SQLAlchemy query logging
- **API Testing**: Use tools like Postman or curl

### Frontend Debugging  
- **React DevTools**: Inspect component state and props
- **Browser DevTools**: Monitor network requests and console errors
- **Vite HMR**: Hot module replacement for instant updates
- **Console Logging**: Use `console.log()` strategically

### Common Issues and Solutions

1. **CORS Errors**: Check Flask CORS configuration
2. **SSL Certificate Issues**: Verify certificates in `kdes/kairos/config/`
3. **JWT Token Expiration**: Handled automatically by ApiBroker
4. **Database Connection**: Check PostgreSQL service and connection settings
5. **Port Conflicts**: Ensure ports 3000 (frontend) and 5002 (backend) are available

## 🔒 Security Considerations

### Development vs Production
- **Development**: Uses self-signed SSL certificates
- **Production**: Requires valid SSL certificates
- **Environment Variables**: Store sensitive data in `.env` files (never commit these)

### Authentication Flow
1. **Login**: User credentials → JWT token
2. **API Calls**: JWT token automatically added by ApiBroker
3. **Token Refresh**: Handled automatically when tokens expire
4. **Logout**: Token invalidation on client side

## 📊 Performance Monitoring

### Development Performance
- **Vite Dev Server**: Fast hot reloading for frontend changes
- **Flask Debug**: Automatic reloading for backend changes
- **Database Queries**: Monitor slow queries in development logs

### Production Considerations
- **Frontend**: Build optimization with Vite
- **Backend**: WSGI server (not Flask dev server)
- **Database**: Connection pooling and query optimization
- **Caching**: Redis for session and application caching

---

## 💡 Pro Tips

1. **Use the ApiBroker pattern religiously** - it handles authentication, error handling, and consistency
2. **Comment your code extensively** - future you (and your teammates) will thank you
3. **Test the complete user journey** - not just individual components
4. **Keep frontend and backend in sync** - when changing APIs, update both sides
5. **Use Socket.IO for real-time features** - it's already configured and ready to use
