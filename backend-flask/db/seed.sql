-- this file was manually created
INSERT INTO public.users (display_name, email, handle, cognito_user_id)
VALUES

  ('Energetic AWS','jereaws+23@gmail.com' , 'energeticaws' ,'abae3b92-4f01-4c9e-855a-dfe0aee05b20'),
  ('Andrew Bayko','bayko@exampro.co' , 'bayko' ,'MOCK'),
  ('Londo Mollari','lmollari@centari.com' ,'londo' ,'MOCK');
  

INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'energeticaws' LIMIT 1),
    'This was imported as seed data!',
    current_timestamp + interval '10 day'
  )