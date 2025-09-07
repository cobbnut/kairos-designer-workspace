# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Kairos Designer is a full-stack application consisting of:
- **Frontend (kdes-fe)**: React 18 + Vite + JavaScript with rich text editing, file uploads, and real-time communication
- **Backend (kdes)**: Python Flask + SQLAlchemy API server with OpenAI integration, Socket.IO, and PostgreSQL

Both applications work as an integrated project with disciplined API architecture and real-time synchronization.

## Development Commands

### Quick Start
```powershell
# Complete setup (first time)
.\scripts\setup-env.ps1

# Daily development (starts both servers)
.\scripts\start-dev.ps1

# Backend only
.\scripts\start-dev.ps1 -BackendOnly

# Frontend only  
.\scripts\start-dev.ps1 -FrontendOnly
```

### Manual Development
```powershell
# Backend (Flask server on https://kairos:5002)
cd kdes
venv\Scripts\Activate.ps1
python run.py

# Frontend (Vite dev server on http://localhost:3000)
cd kdes-fe
npm install
npm run dev
```

### Build & Testing
```powershell
# Frontend build
cd kdes-fe
npm run build        # Production build
npm run lint         # ESLint checking
npm run build-icons  # Build icon manifest

# Frontend development
npm run preview      # Preview production build
```

## Critical Architecture Rules

### MANDATORY: ApiBroker Pattern
**NEVER make direct fetch() calls to the backend.** Always use the ApiBroker pattern:

```javascript
// ✅ CORRECT: Use ApiBroker via functional modules
import ApiBroker from "../api/apiBroker";
const apiBroker = new ApiBroker("/api");

export const newApiCall = async (params) => {
  return apiBroker.request("/endpoint", "POST", data);
};

// ❌ FORBIDDEN: Never do direct fetch calls
const badApiCall = async () => {
  const response = await fetch('https://kairos:5002/api/endpoint');
  return response.json();
};
```

### API Organization
All new APIs must be added to appropriate functional modules:
- `authApi.js` - Authentication, user management, OAuth
- `functionalApi.js` - Core business logic, CRUD operations
- `assistantApi.js` - AI assistant functionality
- `contentApi.js` - Content management
- `sysadminApi.js` - System administration
- `externalApi.js` - External service integration

## High-Level Architecture

### Frontend Architecture (kdes-fe)
- **Core Framework**: React 18 with hooks and contexts, no class components
- **Build System**: Vite for fast development and optimized production builds
- **Routing**: React Router DOM v7 with route-level code splitting
- **State Management**: React contexts (ChatContext) + custom hooks, no Redux
- **API Layer**: Centralized ApiBroker pattern handles all HTTP communication
- **Real-time**: Socket.IO client for live updates and notifications
- **UI Framework**: Bootstrap 5 + React Bootstrap for consistent styling
- **Rich Text**: Multiple editors (Lexical, Quill, Monaco) for different use cases
- **File Handling**: Uppy for uploads with drag-drop and progress tracking

### Backend Architecture (kdes)
- **Web Framework**: Flask with blueprint-based modular architecture
- **Database**: SQLAlchemy ORM with PostgreSQL, connection pooling ready
- **Authentication**: JWT tokens with automatic refresh, OAuth support
- **API Design**: RESTful endpoints organized by functional blueprints
- **Real-time**: Flask-SocketIO for WebSocket communication
- **AI Integration**: OpenAI API integration for assistant functionality
- **File Management**: Secure UUID-based file downloads with authentication
- **Configuration**: Environment-based config with SSL certificate support

### Communication Flow
```
React Components → ApiBroker → Flask Blueprints → SQLAlchemy → PostgreSQL
       ↕                                ↕
Socket.IO Client ←→ Flask-SocketIO (real-time updates)
```

### Directory Structure Significance
```
kdes-fe/src/
├── api/              # CRITICAL: All API communication via ApiBroker
│   ├── apiBroker.js  # Core HTTP client with auth & error handling
│   └── *Api.js       # Functional API modules (auth, content, etc.)
├── components/       # Reusable UI components with rich text editors
├── contexts/         # React state management (ChatContext, etc.)
├── hooks/           # Custom hooks for API integration & state
├── pages/           # Route-level components for main application views
└── utils/           # Frontend utility functions

kdes/kairos/
├── blueprints/      # Flask route organization by functional area
│   ├── api/         # Main API routes (entities, content, chat)
│   ├── auth/        # Authentication endpoints
│   └── files/       # File upload/download handling
├── models/          # SQLAlchemy database models
├── assistant/       # OpenAI integration & AI assistant logic
├── config/          # SSL certificates & configuration files
└── utils/           # Backend utility functions & API formatting
```

## Key Technical Patterns

### Full-Stack Feature Development
1. **Design API contract** - Define endpoints, data structures, error cases
2. **Implement Flask blueprint** - Add backend endpoints with rich comments
3. **Add ApiBroker API calls** - Create frontend API functions in appropriate module
4. **Build React components** - UI components that consume the APIs
5. **Add Socket.IO events** - Real-time updates for data synchronization
6. **Test complete flow** - End-to-end user journey validation

### Authentication Flow
- JWT tokens managed automatically by ApiBroker
- Token refresh handled transparently
- Protected routes require `@jwt_required()` decorator in Flask
- Frontend contexts handle user state and permissions

### Real-time Updates
- Backend emits Socket.IO events on data changes
- Frontend components subscribe to relevant events
- ChatContext manages real-time chat functionality
- Automatic UI updates without manual refresh

### File Handling
- Uppy handles frontend file uploads with progress tracking
- Backend processes files with UUID-based secure storage
- ApiBroker's `downloadFile()` method for authenticated downloads
- Support for multiple file types and drag-drop interfaces

## Development Environment

### Environment Configuration
- **Frontend**: `VITE_API_BASE_URL=https://kairos:5002` (development)
- **Backend**: HTTPS on port 5002 with self-signed SSL certificates
- **Database**: PostgreSQL connection configured in `kdes/kairos/config.py`
- **Hot Reloading**: Both Vite and Flask support automatic reloading

### Security Features
- **HTTPS Development**: All communication encrypted with SSL certificates
- **JWT Authentication**: Centralized token management via ApiBroker
- **CORS Configuration**: Proper cross-origin request handling
- **File Security**: UUID-based authenticated file access

## Technology Stack Summary

### Frontend Dependencies
- **React 18.3.1** + **React DOM** - Modern React with concurrent features
- **Vite 6.0.5** - Fast build tool with hot module replacement
- **React Router DOM 7.1.3** - Client-side routing with suspense
- **Bootstrap 5.3.3** + **React Bootstrap 2.10.9** - UI components
- **Lexical 0.33.1** + **Quill 2.0.3** + **Monaco Editor** - Rich text editing
- **@dnd-kit 6.3.1** - Drag and drop functionality
- **Uppy 4.x** - File upload handling with dashboard
- **Mermaid 11.8.1** - Diagram rendering
- **Socket.IO Client** - Real-time WebSocket communication

### Backend Dependencies
- **Flask 3.1.0** + **Flask-SQLAlchemy 3.1.1** - Web framework + ORM
- **Flask-SocketIO 5.5.1** - WebSocket support
- **PostgreSQL** - psycopg 3.2.5 + psycopg2-binary 2.9.10
- **PyJWT 2.10.1** - JWT token handling
- **OpenAI 1.82.0** - AI assistant integration
- **Redis 5.2.1** - Caching and session storage
- **Flask-CORS 5.0.1** - Cross-origin resource sharing

## Code Standards

### Rich Comments (MANDATORY)
Always comment code extensively for maintainability:
- Document function purposes, parameters, and return values
- Explain complex business logic and architectural decisions
- Update existing comments when modifying code
- Include TODO/FIXME comments for future improvements

### API Development
- Use descriptive endpoint names following RESTful conventions
- Implement proper HTTP status codes and error responses
- Add authentication decorators where needed
- Include request/response documentation in comments

### Frontend Components
- Use functional components with hooks
- Implement proper prop types and default values
- Handle loading and error states in UI
- Follow Bootstrap styling patterns consistently
