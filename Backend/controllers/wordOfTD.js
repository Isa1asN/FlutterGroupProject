import WordOfTD from "../models/wordOfTD.js";
import TodaysWord from "../models/todaysWord.js";


export const setWordOfTD = async (req, res) => {
    try {
        await TodaysWord.deleteMany({})

        const {
            createdBy,
            localId,
            word,
            category,
            meaning, 
            example
        } = req.body;
        console.log(req.body)
        
        await WordOfTD.deleteOne({localId:localId,createdBy:createdBy})
    
        const setWord = new TodaysWord({
            word,
            category,
            meaning,
            example
        })

        const savedWord = await setWord.save();

        res.status(201).json(savedWord);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
}

export const getTodaysWord = async (req,res) => {
    try {
        var word = await TodaysWord.find({});
        const newWord = {
            _id : word[0]._id,
            id : word[0]._id,
            word:word[0].word,
            category:word[0].category,
            meaning : word[0].meaning,
            example : word[0].example,
        }
        console.log(newWord)
        res.json({ word:[newWord] });
      } catch (error) {
        console.log(error);
        res.status(500).json({ error: 'Internal Server Error' });
      }
  }

export const createWordOfTD = async (req, res) => {
    try {
        const {
            word,
            category,
            meaning, 
            example,
            localId
        } = req.body;
        const createdBy = req.user.id
        console.log(req.body)
        console.log(req.body)
        const newWord = new WordOfTD({
            word,
            category,
            meaning,
            example,
            localId,
            createdBy
        })
        
        const savedWord = await newWord.save();
        console.log(savedWord)
        res.status(201).json({savedWord});
    } catch (err) {
        res.status(500).json({error: err.message});
    }
}

export const getWords = async (req, res) => {
    try {
      const words = await WordOfTD.find({});
  
      res.json({ words:words });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

  export const loadMyWords = async (req, res) => {
    try {
        const userId = req.user.id
      const words = await WordOfTD.find({createdBy : userId});
        console.log("words loaded.........", words)
      res.json({ words:words });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

  export const editWord = async (req, res) => {
    try {
      const userId = req.user.id;
    //   console.log(userId)
      const { editAt,word,category,meaning, example } = req.body;
    //   console.log(req.body)
      const updatedWord = await WordOfTD.findOneAndUpdate(
        { localId: editAt, createdBy: userId },
        { word,category, meaning, example },
        { new: true }
      );
  
      if (!updatedWord) {
        return res.status(404).json({ error: 'Word not found' });
      }
      console.log("word successfully edited")
      res.json({ word: updatedWord });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

  export const deleteWord = async (req, res) => {
    try {
      const userId = req.user.id;
      const{ localId }= req.params
      console.log(localId, userId)
      const deletedword = await WordOfTD.findOneAndDelete(
        { localId: parseInt(localId), createdBy: userId },
        { new: true }
      );
  
      if (!deletedword) {
        return res.status(404).json({ error: 'Word not found' });
      }
      console.log("word deleted successfully")
      res.json({ word: deletedword });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };


  