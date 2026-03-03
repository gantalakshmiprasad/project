// server.js - Simple Node.js server to proxy Freepik API requests
const http = require('http');
const https = require('https');
const url = require('url');

const API_KEY = 'FPSX28048925b4722371c79d28177610503c';

const server = http.createServer((req, res) => {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Content-Type', 'application/json');

  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  const parsedUrl = url.parse(req.url, true);
  const query = parsedUrl.query.q;

  if (!query) {
    res.writeHead(400);
    res.end(JSON.stringify({ error: 'Missing query parameter' }));
    return;
  }

  // First request - Search
  const searchUrl = `https://api.freepik.com/v1/resources?query=${encodeURIComponent(query)}&limit=1`;
  const searchReq = https.get(searchUrl, {
    headers: {
      'x-freepik-api-key': API_KEY,
      'Accept': 'application/json'
    }
  }, (searchRes) => {
    let data = '';
    searchRes.on('data', chunk => data += chunk);
    searchRes.on('end', () => {
      try {
        const searchData = JSON.parse(data);
        if (!searchData.data || searchData.data.length === 0) {
          res.writeHead(404);
          res.end(JSON.stringify({ error: 'No images found' }));
          return;
        }

        const resourceId = searchData.data[0].id;

        // Second request - Download URL
        const downloadUrl = `https://api.freepik.com/v1/resources/${resourceId}/download`;
        const downloadReq = https.get(downloadUrl, {
          headers: {
            'x-freepik-api-key': API_KEY,
            'Accept': 'application/json'
          }
        }, (downloadRes) => {
          let downloadData = '';
          downloadRes.on('data', chunk => downloadData += chunk);
          downloadRes.on('end', () => {
            try {
              const result = JSON.parse(downloadData);
              res.writeHead(200);
              res.end(JSON.stringify(result));
            } catch (e) {
              res.writeHead(500);
              res.end(JSON.stringify({ error: 'Invalid JSON response' }));
            }
          });
        });

        downloadReq.on('error', () => {
          res.writeHead(500);
          res.end(JSON.stringify({ error: 'Download request failed' }));
        });
      } catch (e) {
        res.writeHead(500);
        res.end(JSON.stringify({ error: 'Invalid JSON response' }));
      }
    });
  });

  searchReq.on('error', () => {
    res.writeHead(500);
    res.end(JSON.stringify({ error: 'Search request failed' }));
  });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Freepik proxy server running on port ${PORT}`);
});
