-- Supabase seed for ontology defaults.
-- Uses NULL knowledge_base_id to register global node/edge types and fields.

do $$
declare
  v_person uuid;
  v_location uuid;
  v_event uuid;
  v_interest uuid;
  v_group uuid;
  v_note uuid;

  v_knows uuid;
  v_friend_of uuid;
  v_partner_of uuid;
  v_parent_of uuid;
  v_likes uuid;
  v_dislikes uuid;
  v_lives_in uuid;
  v_from uuid;
  v_visited uuid;
  v_attended uuid;
  v_involved_in uuid;
  v_occurred_at uuid;
  v_member_of uuid;
begin
  -- Node types
  insert into public.node_types (id, knowledge_base_id, name, label, description, is_builtin)
  values (gen_random_uuid(), null, 'PERSON', 'Person', 'Individual person', true)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_person;

  insert into public.node_types (id, knowledge_base_id, name, label, description, is_builtin)
  values (gen_random_uuid(), null, 'LOCATION', 'Location', 'Geographic or place reference', true)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_location;

  insert into public.node_types (id, knowledge_base_id, name, label, description, is_builtin)
  values (gen_random_uuid(), null, 'EVENT', 'Event', 'Single or multi-day event', true)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_event;

  insert into public.node_types (id, knowledge_base_id, name, label, description, is_builtin)
  values (gen_random_uuid(), null, 'INTEREST', 'Interest', 'Interest, hobby, or topic', true)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_interest;

  insert into public.node_types (id, knowledge_base_id, name, label, description, is_builtin)
  values (gen_random_uuid(), null, 'GROUP', 'Group', 'Family, friends, or organization', true)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_group;

  insert into public.node_types (id, knowledge_base_id, name, label, description, is_builtin)
  values (gen_random_uuid(), null, 'NOTE', 'Note', 'Freeform note or snippet', true)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_note;

  -- Node type fields: PERSON
  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_person, 'birth_date', 'date', false, null, 'ISO date YYYY-MM-DD')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_person, 'birth_place_id', 'string', false, null, 'Node id of birth location (LOCATION)')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_person, 'notes', 'string', false, null, 'Free-text notes')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_person, 'gender', 'string', false, null, 'Optional gender descriptor')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_person, 'pronouns', 'string', false, null, 'Pronouns, e.g., she/her')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_person, 'tags', 'string_array', false, null, 'Tags for grouping/filtering')
  on conflict (node_type_id, key) do nothing;

  -- LOCATION
  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_location, 'kind', 'string', false, '["city","country","venue","neighborhood","address","region"]'::jsonb, 'Location category')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_location, 'country', 'string', false, null, 'Country name or code')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_location, 'region', 'string', false, null, 'Region/state/province')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_location, 'coordinates', 'json', false, null, 'Object with lat/lon')
  on conflict (node_type_id, key) do nothing;

  -- EVENT
  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_event, 'kind', 'string', false, '["birthday","birthday_party","wedding","anniversary","move","new_job","graduation","breakup","other"]'::jsonb, 'Event category')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_event, 'date', 'date', false, null, 'Single-day date (ISO)')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_event, 'start_date', 'date', false, null, 'Start date (ISO)')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_event, 'end_date', 'date', false, null, 'End date (ISO)')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_event, 'notes', 'string', false, null, 'Event notes')
  on conflict (node_type_id, key) do nothing;

  -- INTEREST
  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_interest, 'category', 'string', false, '["hobby","genre","food","sport","media","topic","other"]'::jsonb, 'Interest category')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_interest, 'notes', 'string', false, null, 'Interest notes')
  on conflict (node_type_id, key) do nothing;

  -- GROUP
  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_group, 'kind', 'string', false, '["family","friends","coworkers","organization","online_community","other"]'::jsonb, 'Group category')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_group, 'notes', 'string', false, null, 'Group notes')
  on conflict (node_type_id, key) do nothing;

  -- NOTE
  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_note, 'body', 'string', false, null, 'Full note text')
  on conflict (node_type_id, key) do nothing;

  insert into public.node_type_fields (id, node_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_note, 'tags', 'string_array', false, null, 'Tags for classification')
  on conflict (node_type_id, key) do nothing;

  -- Edge types
  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'KNOWS', 'Knows', 'Person knows person', 'PERSON', 'PERSON', false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_knows;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'FRIEND_OF', 'Friend Of', 'Friendship between people', 'PERSON', 'PERSON', false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_friend_of;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'PARTNER_OF', 'Partner Of', 'Romantic partner/spouse', 'PERSON', 'PERSON', false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_partner_of;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'PARENT_OF', 'Parent Of', 'Parent to child relationship', 'PERSON', 'PERSON', false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_parent_of;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'LIKES', 'Likes', 'Person likes person or interest', 'PERSON', null, false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_likes;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'DISLIKES', 'Dislikes', 'Person dislikes person or interest', 'PERSON', null, false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_dislikes;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'LIVES_IN', 'Lives In', 'Person lives in location', 'PERSON', 'LOCATION', false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_lives_in;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'FROM', 'From', 'Person is from location', 'PERSON', 'LOCATION', false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_from;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'VISITED', 'Visited', 'Person visited location', 'PERSON', 'LOCATION', false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_visited;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'ATTENDED', 'Attended', 'Person attended event', 'PERSON', 'EVENT', false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_attended;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'INVOLVED_IN', 'Involved In', 'Person involved in event', 'PERSON', 'EVENT', false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_involved_in;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'OCCURRED_AT', 'Occurred At', 'Event occurred at location', 'EVENT', 'LOCATION', false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_occurred_at;

  insert into public.edge_types (id, knowledge_base_id, name, label, description, from_node_type, to_node_type, is_symmetric)
  values (gen_random_uuid(), null, 'MEMBER_OF', 'Member Of', 'Person member of group', 'PERSON', 'GROUP', false)
  on conflict (knowledge_base_id, name) do update set label = excluded.label
  returning id into v_member_of;

  -- Edge type fields
  -- KNOWS
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_knows, 'since', 'date', false, null, 'Approximate start date')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_knows, 'context', 'string', false, null, 'How they met (school, work, etc.)')
  on conflict (edge_type_id, key) do nothing;

  -- FRIEND_OF
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_friend_of, 'since', 'date', false, null, 'Approximate date friendship started')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_friend_of, 'closeness', 'int', false, null, '1-5 rating of closeness')
  on conflict (edge_type_id, key) do nothing;

  -- PARTNER_OF
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_partner_of, 'since', 'date', false, null, 'Date relationship started')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_partner_of, 'married', 'bool', false, null, 'Whether married')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_partner_of, 'status', 'string', false, '["together","separated","divorced"]'::jsonb, 'Relationship status')
  on conflict (edge_type_id, key) do nothing;

  -- PARENT_OF
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_parent_of, 'adopted', 'bool', false, null, 'Adoptive relationship flag')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_parent_of, 'notes', 'string', false, null, 'Additional details')
  on conflict (edge_type_id, key) do nothing;

  -- LIKES
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_likes, 'kind', 'string', false, '["crush","friend","favorite","platonic"]'::jsonb, 'Preference kind')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_likes, 'strength', 'int', false, null, '1-5 preference strength')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_likes, 'since', 'date', false, null, 'Since when')
  on conflict (edge_type_id, key) do nothing;

  -- DISLIKES
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_dislikes, 'strength', 'int', false, null, '1-5 intensity')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_dislikes, 'since', 'date', false, null, 'Since when')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_dislikes, 'reason', 'string', false, null, 'Optional explanation')
  on conflict (edge_type_id, key) do nothing;

  -- LIVES_IN
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_lives_in, 'since', 'date', false, null, 'Start date of residence')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_lives_in, 'until', 'date', false, null, 'End date of residence')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_lives_in, 'is_primary', 'bool', false, null, 'Primary current address flag')
  on conflict (edge_type_id, key) do nothing;

  -- FROM
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_from, 'kind', 'string', false, '["birthplace","grew_up"]'::jsonb, 'Birthplace or grew up')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_from, 'notes', 'string', false, null, 'Additional details')
  on conflict (edge_type_id, key) do nothing;

  -- VISITED
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_visited, 'date', 'date', false, null, 'Visit date or approximate')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_visited, 'times', 'int', false, null, 'Approximate count of visits')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_visited, 'notes', 'string', false, null, 'Additional context')
  on conflict (edge_type_id, key) do nothing;

  -- ATTENDED
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_attended, 'role', 'string', false, '["host","guest","officiant","organizer","speaker"]'::jsonb, 'Attendance role')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_attended, 'notes', 'string', false, null, 'Additional details')
  on conflict (edge_type_id, key) do nothing;

  -- INVOLVED_IN
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_involved_in, 'role', 'string', false, null, 'Free-form description of involvement')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_involved_in, 'notes', 'string', false, null, 'Additional details')
  on conflict (edge_type_id, key) do nothing;

  -- OCCURRED_AT
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_occurred_at, 'notes', 'string', false, null, 'Extra detail on location (room, building, etc.)')
  on conflict (edge_type_id, key) do nothing;

  -- MEMBER_OF
  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_member_of, 'since', 'date', false, null, 'When membership started')
  on conflict (edge_type_id, key) do nothing;

  insert into public.edge_type_fields (id, edge_type_id, key, value_type, required, allowed_values, description)
  values (gen_random_uuid(), v_member_of, 'role', 'string', false, null, 'Role in group (admin, member, leader)')
  on conflict (edge_type_id, key) do nothing;
end;
$$;
