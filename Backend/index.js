import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import bodyParser from "body-parser";
import {router} from "./routes/authRoutes.js"
import User from "./models/user.js";
dotenv.config();

const app = express();
app.use(bodyParser.json());


app.get('/', (req, res) => {
    User.find({})
        .then(found => {
            res.send(found);
        })
        .catch(err => {
            console.log(err);
            res.status(500).send("Some error occurred!");
        });
});
// app.get('/del', (req, res) => {
//     User.deleteMany({})
//       .then(() => {
//         res.send('All data deleted successfully.');
//       })
//       .catch((err) => {
//         console.log(err);
//         res.status(500).send('Some error occurred!');
//       });
//   });
  


// Route Middlewares
app.use('/api', router);

const PORT = process.env.PORT || 5000;
mongoose.connect(process.env.MONGO_URL,{
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).then(()=>{
    app.listen(PORT, ()=> console.log(`Server runnning on port: ${PORT}`))
}).catch((error) => console.log(`${error} did not connect`))



