<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
  <style>
    body { font-family: Arial; background: #f0f2f5; display: flex; 
           justify-content: center; align-items: center; height: 100vh; margin: 0; }
    .box { background: white; padding: 40px; border-radius: 10px; 
           box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 320px; }
    h2 { text-align: center; color: #1F4E79; }
    input { width: 100%; padding: 10px; margin: 10px 0; 
            border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; }
    button { width: 100%; padding: 10px; background: #1F4E79; 
             color: white; border: none; border-radius: 5px; cursor: pointer; }
    button:hover { background: #16375a; }
    .error { color: red; text-align: center; }
  </style>
</head>
<body>
  <div class="box">
    <h2>DevOps Portal</h2>
    <form action="login" method="post">
      <input type="text" name="username" placeholder="Username" required/>
      <input type="password" name="password" placeholder="Password" required/>
      <button type="submit">Login</button>
    </form>
    <p class="error">${error}</p>
  </div>
</body>
</html>
