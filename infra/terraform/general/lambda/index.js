exports.handler = async (event) => {
  const jwt = require('jsonwebtoken');

  const secret = process.env.JWT_SECRET || 'dev-secret-change-me';
  const apiKeyHeader = event.headers && (event.headers['X-Parse-REST-API-Key'] || event.headers['x-parse-rest-api-key']);
  const token = event.headers && (event.headers['X-JWT-KWY'] || event.headers['x-jwt-kwy']);

  if (!apiKeyHeader || apiKeyHeader !== '2f5ae96c-b558-4c7b-a590-a501ae1c3f6c') {
    return generatePolicy('user', 'Deny', event.methodArn);
  }

  try {
    const decoded = jwt.verify(token, secret);
    return generatePolicy(decoded.sub || 'user', 'Allow', event.methodArn);
  } catch (e) {
    return generatePolicy('user', 'Deny', event.methodArn);
  }
};

const generatePolicy = function(principalId, effect, resource) {
  const authResponse = {};
  authResponse.principalId = principalId;
  if (effect && resource) {
    const policyDocument = {};
    policyDocument.Version = '2012-10-17';
    policyDocument.Statement = [];
    const stmt = {};
    stmt.Action = 'execute-api:Invoke';
    stmt.Effect = effect;
    stmt.Resource = resource;
    policyDocument.Statement[0] = stmt;
    authResponse.policyDocument = policyDocument;
  }
  return authResponse;
};
