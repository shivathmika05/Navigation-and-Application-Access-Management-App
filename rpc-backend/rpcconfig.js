import { RetoolRPC } from "retoolrpc";
import fetch from "node-fetch";
import dotenv from "dotenv";

dotenv.config();

const BASE_URL = process.env.RAILS_BASE_URL || "http://localhost:3000";
const ACCESS_LEVEL_MAP = {
    "Read": 1,
    "Read,Write": 2,
    "Read,Write,Delete": 3
  };
const rpc = new RetoolRPC({
  apiToken: process.env.RETOOL_API_TOKEN,
  host: process.env.RETOOL_HOST,
  resourceId: process.env.RETOOL_RESOURCE_ID,
  environmentName: 'production',
  pollingIntervalMs: 1000,
  version: '0.0.1',
  logLevel: 'info',
});

rpc.register({
    name: 'getUsers',
    arguments: {}, 
    implementation: async () => {
      const response = await fetch(`${BASE_URL}/users`);
      return response.json();
    },
  });
  


rpc.register({
  name: 'getUserByEmail',
  arguments: {
    email: { type: "string" },
  },
  implementation: async ({ email }) => {
    if (!email) throw new Error('Email is required');

    const response = await fetch(
      `${BASE_URL}/users/by_email?email=${encodeURIComponent(email)}`
    );

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to fetch user');
    }

    const userData = await response.json();

    const permissions = {
      can_create: userData.is_admin,
      can_edit: userData.is_admin,
      can_delete: userData.is_admin,
    };

    return {
      ...userData,
      permissions: permissions,
    };
  },
});

  
rpc.register({
    name: 'getUserByEmailWithApp',
    arguments: {
      email: { type: "string", required: true },
      appId: { type: "string", required: true },
    },
    implementation: async ({ email, appId }) => {
      if (!email) throw new Error('Email is required');
      if (!appId) throw new Error('appId is required');
  
      const response = await fetch(
        `${BASE_URL}/users/by_email_with_app/${encodeURIComponent(email)}/${appId}`
      );
  
      if (!response.ok) {
        const error = await response.json().catch(() => ({}));
        throw new Error(error.error || 'Failed to fetch user');
      }
  
      const userData = await response.json();
      const accessLevel = (userData.access_level || "").toLowerCase();
  
      const permissions = {
        can_create: accessLevel.includes("write"),
        can_edit: accessLevel.includes("write"),
        can_delete: accessLevel.includes("delete"),
      };
  
      return {
        ...userData,
        appId, // include appId in response
        permissions,
      };
    },
  });
  
  
  rpc.register({
    name: "createUser",
    arguments: { name: { type: "string" }, email: { type: "string" }, is_admin: { type: "boolean" } },
    implementation: async ({ name, email, is_admin }) => {
      const BASE_URL = process.env.BASE_URL || "http://127.0.0.1:3000";
      const response = await fetch(`${BASE_URL}/users`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name, email, is_admin })
      });
      const data = await response.json();
      if (!response.ok) {
        throw new Error(data.errors?.join(", ") || data.exception || "Failed to create user");
      }
      return data;
    }
  });
  
  rpc.register({
    name: 'updateUser',
    arguments: { 
      id: { type: 'string', required: true },
      name: { type: 'string', required: true },
      is_admin: { type: "boolean" }
    },
    implementation: async ({ id, name, is_admin }) => {
      const BASE_URL = process.env.BASE_URL || 'http://127.0.0.1:3000';
      if (!id || id === 'null' || id === 'undefined') {
        throw new Error("Invalid user ID provided.");
      }
      const payload = {
        user: {
          name: name,
          is_admin: is_admin
        }
      };
      const response = await fetch(`${BASE_URL}/users/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });
      if (!response.ok) {
        const errorData = await response.json().catch(() => null);
        let errorMessage = `Failed to update user. Status: ${response.status}`;
        if (errorData && errorData.errors) {
          errorMessage = `Failed to update user: ${errorData.errors.join(', ')}`;
        }
        throw new Error(errorMessage);
      }   
      return response.json();
    }
  });

  rpc.register({
    name: 'deleteUser',
    arguments: { 
      id: { type: 'string', required: true } 
    },
    implementation: async ({ id }) => {
      const BASE_URL = process.env.BASE_URL || 'http://127.0.0.1:3000';
      const response = await fetch(`${BASE_URL}/users/${id}`, {
        method: 'DELETE',
      });
      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || `Failed to delete user with ID ${id}`);
      }  
      return response.json();
    },
  });
  

  rpc.register({
    name: 'getApplications',
    arguments: {}, 
    implementation: async () => {
      const response = await fetch(`${BASE_URL}/applications`);
      return response.json();
    },
  });
  
  rpc.register({
    name: 'createApplication',
    arguments: {
      name: { type: 'string' },
      description: { type: 'string' },
      app_url: { type: 'string' }
    },
    implementation: async ({ name, description, app_url }) => {
      const BASE_URL = process.env.BASE_URL || 'http://127.0.0.1:3000';

      const payload = {
        application: {
          name: name,
          description: description,
          app_url: app_url
        }
      };
      const response = await fetch(`${BASE_URL}/applications`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`Failed to create application: ${errorData.errors.join(', ')}`);
      }

      return response.json();
    }
});
  
rpc.register({
    name: 'getApplicationById',
    arguments: { id: { type: 'string', required: true } },
    implementation: async ({ id }) => {
      const url = `${BASE_URL}/applications/${id}`;
            const response = await fetch(url);
        if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || `Failed to fetch application with ID ${id}`);
      }
        return response.json();
    },
  });


  rpc.register({
    name: 'getAppPermissions',
    arguments: {
        userId: { type: 'string', required: true },
        appId: { type: 'string', required: true },
    },
    implementation: async ({ userId, appId, access_level }) => {
        const response = await fetch(
            `${BASE_URL}/permissions/${userId}/apps/${appId}`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                },
            }
        );
        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || `Failed to fetch permission for user ${userId} and app ${appId}`);
        }
        return response.json();
    },
});
  
rpc.register({
    name: "getAppEvents",
    arguments: {
        accessLevel: { type: "string", required: false }
    },
    implementation: async () => {
      const response = await fetch(`${BASE_URL}/api/v1/app_events`);
      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || "Failed to fetch app events");
      }
      return response.json();
    },
  });
  
  rpc.register({
    name: "createAppEvent",
    arguments: {
      name: { type: "string", required: true },
      location: { type: "string", required: true },
      date: { type: "string", required: true }
    },
    implementation: async ({ name, location, date }) => {
      const payload = { app_event: { name, location, date } };
      const response = await fetch(`${BASE_URL}/api/v1/app_events`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
  
      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.errors?.join(", ") || errorData.error || "Failed to create app event");
      }
      return response.json();
    },
  });
  
  rpc.register({
    name: "updateAppEvent",
    arguments: {
      id: { type: "string", required: true },
      name: { type: "string" },
      location: { type: "string" },
      date: { type: "string" },
    },
    implementation: async ({ id, name, location, date }) => {
      const payload = { app_event: {} };
      if (name) payload.app_event.name = name;
      if (location) payload.app_event.location = location;
      if (date) payload.app_event.date = date;
  
      if (Object.keys(payload.app_event).length === 0) {
        throw new Error("At least one field (name, location, date) must be provided");
      }
  
      const response = await fetch(`${BASE_URL}/api/v1/app_events/${id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
  
      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.errors?.join(", ") || errorData.error || `Failed to update app event ${id}`);
      }
  
      return response.json();
    },
  });
  
  rpc.register({
    name: "deleteAppEvent",
    arguments: {
      id: { type: "string", required: true },
    },
    implementation: async ({ id }) => {
      const response = await fetch(`${BASE_URL}/api/v1/app_events/${id}`, {
        method: "DELETE",
      });
  
      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || `Failed to delete app event ${id}`);
      }
  
      return { success: true, message: `AppEvent ${id} deleted` };
    },
  });
  

rpc.register({
    name: 'updateApplication',
    arguments: {
        id: { type: 'string', required: true },
        name: { type: 'string' },
        app_url: { type: 'string' },
        description: { type: 'string' }
    },
    implementation: async ({ id, name, app_url, description }) => {
        const payload = {
            application: {
                ...(name !== undefined && { name }),
                ...(app_url !== undefined && { app_url }),
                ...(description !== undefined && { description })
            }
        };
        if (Object.keys(payload.application).length === 0) {
            throw new Error('At least one of "name", "app_url", or "description" must be provided for update.');
        }
        const response = await fetch(`${BASE_URL}/applications/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.errors.join(', ') || `Failed to update application with ID: ${id}`);
        }
        return response.json();
    },
});


  rpc.register({
    name: 'deleteApplication',
    arguments: { 
      id: { type: 'string', required: true } 
    },
    implementation: async ({ id }) => {
      const BASE_URL = process.env.BASE_URL || 'http://127.0.0.1:3000';
            const response = await fetch(`${BASE_URL}/applications/${id}`, {
        method: 'DELETE',
      });
      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || `Failed to delete application with ID ${id}`);
      }
      return response.json();
    },
  });


rpc.register({
    name: 'getPermissions',
    arguments: { user_id: { type: 'string', required: false } },
    implementation: async ({ user_id }) => {
      const response = await fetch(`${BASE_URL}/permissions${user_id ? `?user_id=${user_id}` : ''}`);
      return response.json();
    },
  });
 

  rpc.register({
    name: 'getPermissionsByUser',
    arguments: { 
      user_id: { type: 'string', required: true } 
    },
    implementation: async ({ user_id }) => {
      try {
        const response = await fetch(`${BASE_URL}/permissions/${user_id}/apps`);
        if (!response.ok) {
          let errorMessage = `Failed to fetch permission for user ${user_id}`;
          try {
            const errorData = await response.json();
            errorMessage = errorData.error || errorMessage;
          } catch (err) {
          }
          throw new Error(errorMessage);
        }
        return await response.json(); 
      } catch (err) {
        console.error(err);
        throw err;
      }
    },
  });
  
  

  rpc.register({
    name: 'createPermission',
    arguments: {
      userId: { type: 'number', required: true },
      applicationId: { type: 'number', required: true },
      accessLevel: { type: 'string', required: true }
    },
    implementation: async (args) => {
      const ACCESS_LEVEL_MAP = {
        "read": 1,
        "read,write": 2,
        "read,write,delete": 3,
        "Read": 1,
        "Read,Write": 2,
        "Read,Write,Delete": 3
      };
      const level = ACCESS_LEVEL_MAP[args.accessLevel];
      if (!level) {
        throw new Error(`Invalid access level: ${args.accessLevel}. Please provide one of the following: "Read", "Read,Write", or "Read,Write,Delete".`);
      }
      const response = await fetch(`${BASE_URL}/permissions`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          user_id: args.userId,
          application_id: args.applicationId,
          access_level: level 
        })
      });
      const data = await response.json();
      if (!response.ok) {
          throw new Error(data.errors?.join(", ") || data.error || "Failed to create permission");
      }
      return data;
    },
  });

rpc.register({
    name: 'grantAccess',
    arguments: {
      userId: { type: 'string', required: true },
      applicationId: { type: 'string', required: true },
      accessLevel: { type: 'string', required: true },
    },
    implementation: async ({ userId, applicationId, accessLevel }) => {
      const ACCESS_LEVEL_MAP = {
        "read": 1,
        "read,write": 2,
        "read,write,delete": 3,
        "Read": 1,
        "Read,Write": 2,
        "Read,Write,Delete": 3
      };
      const level = ACCESS_LEVEL_MAP[accessLevel];
      if (!level) {
        throw new Error(`Invalid access level: ${accessLevel}. Please provide one of the following: "Read", "Read,Write", or "Read,Write,Delete".`);
      }
      const response = await fetch(
        `${BASE_URL}/permissions/update_by_user/${userId}/${applicationId}`,
        {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ access_level: level }),
        }
      );
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || `Failed to grant access for user ${userId}`);
      }
      return response.json();
    },
  });
  
  
  rpc.register({
    name: 'updatePermissions',
    arguments: {
      userId: { type: 'string', required: true },
      applicationId: { type: 'string', required: true },
      accessLevel: { type: 'string', required: true },
    },
    implementation: async ({ userId, applicationId, accessLevel }) => {
      const response = await fetch(
        `${BASE_URL}/permissions/update_by_user/${userId}/${applicationId}`,
        {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ access_level: accessLevel }),
        }
      );
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || 'Failed to update permission');
      }
      return response.json();
    },
});

  
  
  rpc.register({
    name: 'deletePermission',
    arguments: { 
      user_id: { type: 'string', required: true },
      application_id: { type: 'string', required: true }
    },
    implementation: async (args) => {
      try {
        const url = `${BASE_URL}/permissions/delete_by_user_app/${args.user_id}/${args.application_id}`;
        const response = await fetch(url, { method: "DELETE" });
        if (!response.ok) {
          const errorData = await response.json().catch(() => ({}));
          return {
            success: false,
            status: response.status,
            message: errorData?.error || "Failed to delete permission"
          };
        }
        const data = await response.json().catch(() => ({}));
        return { success: true, ...data };
  
      } catch (err) {
        return { success: false, status: "error", message: err.message };
      }
    },
  });
  


rpc.register({
    name: 'getCurrentUserFromDB',
    arguments: {
      email: { type: 'string', required: true },
    },
    implementation: async ({ email }) => {
      const response = await fetch(`${BASE_URL}/users`);
      const allUsers = await response.json();
      return Array.isArray(allUsers) ? allUsers : allUsers.users; 
    },
  });
  
  
  rpc.register({
    name: 'getCurrentUserPermissions',
    arguments:
    { 
        email: { type: 'string', required: true }, 
        application_id: { type: 'string', required: false }, 
    },
    implementation: async ({ email}) => {
      //  Get current user
      const userResponse = await fetch(`${BASE_URL}/users`);
      const allUsers = await userResponse.json();
      const currentUser = allUsers.find(u => u.email === email);
      if (!currentUser) return []; 
  
      //  Get permissions for that user
      const permResponse = await fetch(`${BASE_URL}/permissions?user_id=${currentUser.id}`);
      const userPermissions = await permResponse.json();
  
      return userPermissions;
    },
  });
  
  
  
rpc.listen();
console.log("RPC backend running...");