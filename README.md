# [Apache Spark Studies](https://jbcodeforce.github.io/spark-studies/)

Better read in [book format.](https://jbcodeforce.github.io/spark-studies/).

## Updates

* 11/7/2022: change spark version and update to doc

## Content

* Dockerfile to build my own spark image to run locally: `docker build -t jbcodeforce/spark .`
* Docker compose to start one master and one worker: `docker compose up -d`

## Building this booklet locally

The content of this repository is written with markdown files, packaged with [MkDocs](https://www.mkdocs.org/) and can be built into a book-readable format by MkDocs build processes.

1. Install MkDocs locally following the [official documentation instructions](https://www.mkdocs.org/#installation).
1. Install Material plugin for mkdocs:  `pip install mkdocs-material` 
2. `git clone https://github.com/jbcodeforce/spark-studies.git` _(or your forked repository if you plan to edit)_
3. `cd spark-studies`
4. `mkdocs serve`
5. Go to `http://127.0.0.1:8000/` in your browser.

### Pushing the book to GitHub Pages

1. Ensure that all your local changes to the `master` branch have been committed and pushed to the remote repository.
   1. `git push origin master`
2. Ensure that you have the latest commits to the `gh-pages` branch, so you can get others' updates.
	```bash
	git checkout gh-pages
	git pull origin gh-pages
	
	git checkout master
	```
3. Run `mkdocs gh-deploy` from the root openshift-spark-studies directory.
