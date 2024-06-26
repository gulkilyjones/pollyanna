#!usr/bin/perl -T

use strict;
use warnings;
use 5.010;
use utf8;


sub IndexPyFile { # $file | 'flush' ; indexes one text file into database
# sub IndexPyhonFile {
# sub IndexPy {
# DRAFT
# DRAFT
# DRAFT
# DRAFT
# DRAFT
	state $SCRIPTDIR = GetDir('script');
	state $HTMLDIR = GetDir('html');
	state $TXTDIR = GetDir('txt');

	my $file = shift;
	chomp($file);

	#todo sanity

	if ($file eq 'flush') {
		DBAddItem('flush');
		DBGetAddedTime('flush');
		DBAddLabel('flush');
		DBAddItemAttribute('flush');
		WriteLog('IndexPyFile: flush');
		return 1;
	}

	if ($file =~ m/^([0-9a-zA-Z\/\._\-]+)$/) {
		$file = $1;
	} else {
		WriteLog('IndexPyFile: warning: $file failed sanity check; $file = ' . $file);
		return '';
	}

	WriteLog('IndexPyFile: $file = ' . $file);

	my $itemName = TrimPath($file);
	my $fileHash = GetFileHash($file);

	DBAddItem($file, $itemName, '', $fileHash, 'py', 0);
	DBAddLabel($fileHash, 0, 'py');

	if (0) {
		# python files do not need compiling
		# this may be useful later
		# e.g. if file was uploaded by someone with admin cookie, run right away and call it compiling?
		# my $compileCommand = "python $file";
		# WriteLog('IndexPyFile: $compileCommand = ' . $compileCommand);

		# my $compileStart = time();
		# my $compileLog = `$compileCommand`;
		# my $compileFinish = time();

		# DBAddItemAttribute($fileHash, 'compile_start', $compileStart);
		#DBAddItemAttribute($fileHash, 'compile_finish', $compileFinish);

		# if ($compileLog) {
		# 	PutCache('compile_log/' . $fileHash, $compileLog); # parse_log parse.log ParseLog
		# }
	}

	my $addedTime = DBGetAddedTime($fileHash);

	# debug output
	WriteLog('IndexPyFile: $file = ' . ($file?$file:'false'));
	WriteLog('IndexPyFile: $fileHash = ' . ($fileHash?$fileHash:'false'));
	WriteLog('IndexPyFile: $addedTime = ' . ($addedTime?$addedTime:'false'));

	if (IsFileDeleted($file, $fileHash)) {
		# write to log
		WriteLog('IndexPyFile: IsFileDeleted() returned true, returning');
		return 0;
	}

	if (!$addedTime) {
		WriteLog('IndexPyFile: file missing $addedTime');
		if (GetConfig('admin/logging/write_chain_log')) {
			$addedTime = AddToChainLog($fileHash);
		} else {
			$addedTime = GetTime();
		}
		if (!$addedTime) {
			# sanity check
			WriteLog('IndexPyFile: warning: sanity check failed for $addedTime');
			$addedTime = GetTime();
		}
	}

	return 1;
} # IndexPyFile()

1;
