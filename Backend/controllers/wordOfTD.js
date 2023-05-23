import WordOfTD from "../models/wordOfTD.js";

export const createWordOfTD = async (req, res) => {
    try {
        const {
            word,
            category,
            meaning, 
            example
        } = req.body;
        
        const newWord = new WordOfTD({
            word,
            category,
            meaning,
            example
        })

        const savedWord = await newWord.save();

        res.status(201).json(savedWord);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
}

export const getWords = async (req, res) => {
    try {
      const words = await WordOfTD.find({});
  
      res.json({ words });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };