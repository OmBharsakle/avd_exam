# Note-Taking App with SQLite and Firebase Integration

## Table of Contents
1. [Introduction](#introduction)
2. [Features](#features)
3. [Prerequisites](#prerequisites)
4. [Getting Started](#getting-started)
5. [Project Structure](#project-structure)
6. [How It Works](#how-it-works)
7. [Demo](#demo)
8. [Credits](#credits)

## Introduction

This is a simple Note-Taking app built with Flutter, SQLite, and Firebase. Users can create, view, edit, and delete notes locally, and back them up to Firebase. The app includes features for categorizing, searching, and sorting notes.

## Features

- **SQLite Note Management**  
  - CRUD (Create, Read, Update, Delete) operations on local notes.
  - Notes have fields: title, content, creation date, and category.
  - Categories: "Work," "Personal," or "Miscellaneous."
  
- **Firebase Cloud Backup**  
  - User login/signup using Firebase Authentication.
  - Notes backup to Firebase Firestore with restore functionality.

- **Search, Filter, and Sort**  
  - Search notes by title or content.
  - Filter by category.
  - Sort notes by creation date or category.

## Prerequisites

- **Flutter** (Version >= 3.0)
- **Firebase Project**  
  - Add Firebase to your Flutter project.
  - Enable Firebase Authentication and Firestore.
 
## Screenshots

<div align="center">

   <img src="https://github.com/user-attachments/assets/9c165323-29a2-4d65-bc19-1100c029cd0f" height="500">
   <img src="https://github.com/user-attachments/assets/68db5744-d187-46d7-a41a-4c398c6b1752" height="500">
   <img src="https://github.com/user-attachments/assets/eaa64e3d-bfac-43c8-8ba9-1345c9ad30d5" height="500">
   <img src="https://github.com/user-attachments/assets/c8a7b9a4-5ed9-479f-9763-9eb2ad1ccb75" height="500">
   <img src="https://github.com/user-attachments/assets/9251ed64-93a3-4efb-960f-776c521780af" height="500">
   <img src="https://github.com/user-attachments/assets/f3820b95-614c-4325-9716-dd5470cb1d9f" height="500">
   <img src="https://github.com/user-attachments/assets/c35bbde5-b36c-4f2a-b5ae-00ebe8585edf" height="500">


</div>

<h1></h1>

## Video Demo

<div align="center">
  


https://drive.google.com/file/d/1M4Dw6c0ytnxP1Y9riQ2SfFo4YTZ2vEVd/view?usp=sharing



</div>

## Getting Started

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/yourusername/note_taking_app
   cd note_taking_app
