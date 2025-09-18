import { RetoolRPC } from "retoolrpc";
import fetch from "node-fetch";
import dotenv from "dotenv";

dotenv.config();

const BASE_URL = process.env.RAILS_BASE_URL || "http://localhost:3000";

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
    name: 'getApplications',
    arguments: {}, 
    implementation: async () => {
      const response = await fetch(`${BASE_URL}/applications`);
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
    arguments: { userId: { type: 'string', required: true } },
    implementation: async (args) => {
      const response = await fetch(`${BASE_URL}/permissions/by_user/${args.userId}`);
      return response.json();
    },
  });

rpc.register({
  name: 'createPermission',
  arguments: { userId: { type: 'number', required: true }, applicationId: { type: 'number', required: true }, accessLevel: { type: 'number', required: true } },
  implementation: async (args) => {
    const response = await fetch(`${BASE_URL}/permissions`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ user_id: args.userId, application_id: args.applicationId, access_level: args.accessLevel })
    });
    return response.json();
  },
});

rpc.register({
  name: 'updatePermissionByUser',
  arguments: { userId: { type: 'number', required: true }, appId: { type: 'number', required: true }, accessLevel: { type: 'number', required: true } },
  implementation: async (args) => {
    const response = await fetch(`${BASE_URL}/permissions/update_by_user/${args.userId}/${args.appId}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ access_level: args.accessLevel })
    });
    return response.json();
  },
});

rpc.register({
  name: 'deletePermission',
  arguments: { 
    user_id: { type: 'number', required: true },
    application_id: { type: 'number', required: true }
  },
  implementation: async (args) => {
    const url = `${BASE_URL}/permissions?user_id=${args.user_id}&application_id=${args.application_id}`;
    const response = await fetch(url, { method: "DELETE" });
    return response.json();
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
    arguments: { email: { type: 'string', required: true } },
    implementation: async ({ email }) => {
      //  Get current user
      const userResponse = await fetch(`${BASE_URL}/users`);
      const allUsers = await userResponse.json();
      const currentUser = allUsers.find(u => u.email === email);
      if (!currentUser) return []; // no user found
  
      //  Get permissions for that user
      const permResponse = await fetch(`${BASE_URL}/permissions?user_id=${currentUser.id}`);
      const userPermissions = await permResponse.json();
  
      return userPermissions;
    },
  });
  
  
  
rpc.listen();
console.log("RPC backend running...");
