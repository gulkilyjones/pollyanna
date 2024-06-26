SELECT 
	file_hash AS file_hash,
	item_title AS item_title,
	item_name AS item_name,
	item_score AS item_score,
	file_path AS file_path,
	item_type AS item_type
FROM
	item_flat
WHERE
	labels_list like '%,image,%' AND
	item_type = 'image' AND
	item_score >= 0
ORDER BY
	add_timestamp DESC
